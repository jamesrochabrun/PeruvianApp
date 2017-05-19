//
//  CameraView.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/18/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreData

protocol CameraViewDelegate: class {
    func showAlertAskingForSave(image: UIImage)
}

class CameraView: BaseView  {
    
    //MARK: Properties
    weak var delegate: CameraViewDelegate?
    fileprivate var movieFileOutput: AVCaptureMovieFileOutput?
    fileprivate var captureSession = AVCaptureSession()
    fileprivate var stillImageOutput = AVCapturePhotoOutput()
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer?
    fileprivate var isFront = false

    fileprivate let sessionQueue = DispatchQueue(label: "session queue", attributes: [], target: nil) // Communicate with the session and other session objects on this queue.
    fileprivate var inProgressPhotoCaptureDelegates = [Int64 : PhotoCaptureDelegate]()
    
    private var setupResult: SessionSetupResult = .success
    fileprivate var videoDeviceInput: AVCaptureDeviceInput!
    
    //MARK: UI elements
    let tempImageView: UIImageView = {
        let iv = UIImageView(frame: UIScreen.main.bounds)
        return iv
    }()
    
    lazy var flipCameraButton: UIButton = {
        let button = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 70, y: 15, width: 55, height: 55))
        button.addTarget(self, action: #selector(changeCamera), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "flip").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    lazy var captureButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.width - 85) / 2, y: UIScreen.main.bounds.height - 110, width: 85, height: 85))
        button.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "whiteJoystick"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    //MARK: Setup UI
    override func setUpViews() {
        configureSession()
        addSubview(tempImageView)
        addSubview(flipCameraButton)
        addSubview(captureButton)
    }
    
    // MARK: Session Management
    private enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    
    //MARK: Configure Session
    private func configureSession() {
        
        if setupResult != .success { return }
        
        captureSession.beginConfiguration()
        //captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        do {
            
            var defaultVideoDevice: AVCaptureDevice?
            
            // Choose the back dual camera if available, otherwise default to a wide angle camera.
            if let dualCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInDuoCamera, mediaType: AVMediaTypeVideo, position: .back) {
                defaultVideoDevice = dualCameraDevice
            }
            else if let backCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back) {
                // If the back dual camera is not available, default to the back wide angle camera.
                defaultVideoDevice = backCameraDevice
            }
            else if let frontCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front) {
                // In some cases where users break their phones, the back wide angle camera is not available. In this case, we should default to the front wide angle camera.
                defaultVideoDevice = frontCameraDevice
            }
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: defaultVideoDevice)
            
            if captureSession.canAddInput(videoDeviceInput) {
                
                captureSession.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                DispatchQueue.main.async {
                    /*
                     Why are we dispatching this to the main queue?
                     Because AVCaptureVideoPreviewLayer is the backing layer for PreviewView and UIView
                     can only be manipulated on the main thread.
                     */

                    self.previewLayer?.connection.videoOrientation = .portrait
                }
                
            } else {
                print("Could not add video device input to the session")
                setupResult = .configurationFailed
                captureSession.commitConfiguration()
                return
            }
        } catch let error {
            print("Error configureSession: \(error)")
            setupResult = .configurationFailed
            captureSession.commitConfiguration()
        }
        
        // Add photo output.
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
            stillImageOutput.isHighResolutionCaptureEnabled = true
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
            previewLayer?.connection.videoOrientation = .portrait
            layer.addSublayer(previewLayer!)
            previewLayer?.frame = UIScreen.main.bounds
        }
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
    
    // MARK: Device Configuration
    
    private let videoDeviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDuoCamera], mediaType: AVMediaTypeVideo, position: .unspecified)!
    
    @objc private func changeCamera() {
        
        flipCameraButton.isEnabled = false
        captureButton.isEnabled = false
        sessionQueue.async {
            
            let currentVideoDevice = self.videoDeviceInput.device
            let currentPosition = currentVideoDevice!.position
            
            let preferredPosition: AVCaptureDevicePosition
            let preferredDeviceType: AVCaptureDeviceType
            
            switch currentPosition {
            case .unspecified, .front:
                preferredPosition = .back
                preferredDeviceType = .builtInDuoCamera
                self.isFront = false
            case .back:
                preferredPosition = .front
                preferredDeviceType = .builtInWideAngleCamera
                self.isFront = true
            }
            
            let devices = self.videoDeviceDiscoverySession.devices!
            var newVideoDevice: AVCaptureDevice? = nil
            
            // First, look for a device with both the preferred position and device type. Otherwise, look for a device with only the preferred position.
            if let device = devices.filter({ $0.position == preferredPosition && $0.deviceType == preferredDeviceType }).first {
                newVideoDevice = device
            }
            else if let device = devices.filter({ $0.position == preferredPosition }).first {
                newVideoDevice = device
            }
            
            if let videoDevice = newVideoDevice {
                do {
                    let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                    
                    self.captureSession.beginConfiguration()
                    
                    // Remove the existing device input first, since using the front and back camera simultaneously is not supported.
                    self.captureSession.removeInput(self.videoDeviceInput)
                    
                    if self.captureSession.canAddInput(videoDeviceInput) {
                        
                        self.captureSession.addInput(videoDeviceInput)
                        self.videoDeviceInput = videoDeviceInput
                    }
                    else {
                        self.captureSession.addInput(self.videoDeviceInput);
                    }
                    
                    if let connection = self.movieFileOutput?.connection(withMediaType: AVMediaTypeVideo) {
                        if connection.isVideoStabilizationSupported {
                            connection.preferredVideoStabilizationMode = .auto
                        }
                    }
                    self.captureSession.commitConfiguration()
                }
                catch {
                    print("Error occured while creating video device input: \(error)")
                }
            }
            DispatchQueue.main.async {
                self.flipCameraButton.isEnabled = true
                self.captureButton.isEnabled = true
            }
        }
    }
}

//MARK: Take photo actions
extension CameraView {
    
    func didPressTakePhoto() {
        
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160,
                             ]
        settings.previewPhotoFormat = previewFormat
        
        let photoCaptureDelegate = PhotoCaptureDelegate(with: settings, capturedPhoto: { [unowned self] (cgImage) in
            
            let orientation: UIImageOrientation = self.isFront ? .leftMirrored : .right
            let image = UIImage(cgImage: cgImage, scale: 1.0, orientation: orientation)
            self.tempImageView.image = image
            self.tempImageView.isHidden = false
            
            self.delegate?.showAlertAskingForSave(image: image)
            //IMAGE SAVE IN COREDATA
            }, completed: { [unowned self] (photoCaptureDelegate) in
                // When the capture is complete, remove a reference to the photo capture delegate so it can be deallocated.
                self.inProgressPhotoCaptureDelegates[photoCaptureDelegate.requestedPhotoSettings.uniqueID] = nil
        })
        
        /*
         The Photo Output keeps a weak reference to the photo capture delegate so
         we store it in an array to maintain a strong reference to this object
         until the capture is completed.
         */
        self.inProgressPhotoCaptureDelegates[photoCaptureDelegate.requestedPhotoSettings.uniqueID] = photoCaptureDelegate
        self.stillImageOutput.capturePhoto(with: settings, delegate: photoCaptureDelegate)
    }
    
    func takePhoto() {
        captureSession.startRunning()
        flipCameraButton.isEnabled = false
        captureButton.isEnabled = false
        didPressTakePhoto()
    }
    
    func retake() {
        tempImageView.isHidden = true
        flipCameraButton.isEnabled = true
        captureButton.isEnabled = true
    }
}
















