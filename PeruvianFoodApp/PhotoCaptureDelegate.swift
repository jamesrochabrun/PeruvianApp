//
//  PhotoCaptureDelegate.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/18/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import AVFoundation

//MARK: this object the delagation of AVCapturePhotoCaptureDelegate
class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    
    private(set) var requestedPhotoSettings: AVCapturePhotoSettings
    private let completed: (PhotoCaptureDelegate) -> ()
    private let capturedPhoto: (CGImage) -> ()
    
    
    init(with requestedPhotoSettings: AVCapturePhotoSettings,
         capturedPhoto: @escaping (CGImage) -> (),
         completed: @escaping (PhotoCaptureDelegate) -> ()) {
        
        self.requestedPhotoSettings = requestedPhotoSettings
        self.completed = completed
        self.capturedPhoto = capturedPhoto
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
        }
        
        guard let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer,
            let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer),
            let dataProvider = CGDataProvider(data: dataImage as CFData),
            let cgImageRef = CGImage.init(jpegDataProviderSource: dataProvider, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent) else {
                print("Error on captureOutput")
                return
        }
        
        capturedPhoto(cgImageRef)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishCaptureForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        completed(self)
    }
}
