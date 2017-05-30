//
//  FoodieVC.swift
//  PeruvianFoodApp
//
//  Created by James Rochabrun on 5/18/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class FoodieFeedVC: UITableViewController {
    
    //MARK: Main object for fetching objects from coredata
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Photo.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
       // frc.delegate = self
        return frc
    }()
    
    //MARK: App lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(FoodiePhotoCell.self)
        updateTableContent()
        tableView.allowsSelection = false
        setUPNavBar()
        self.title = "Favorite food"
    }
    
    //MARK: Setup UI
    private func setUPNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissVC))
    }
    
    //MARK: Navigation
    @objc private func dismissVC() {
        self.dismiss(animated: true)
    }
    
    //MARK: fetch request
    private func updateTableContent() {
        
        do {
            try self.fetchedhResultController.performFetch()
            print("COUNT FETCHED FIRST: \(self.fetchedhResultController.sections?[0].numberOfObjects)")
        } catch let error  {
            print("ERROR: \(error)")
        }
    }
}

//MARK: UItableview delegate and datasource methods
extension FoodieFeedVC {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FoodiePhotoCell
        if let photo = fetchedhResultController.object(at: indexPath) as? Photo {
            cell.setUpCell(with: photo)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedhResultController.sections?.first?.numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

//extension FoodieFeedVC: NSFetchedResultsControllerDelegate {
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        
//        switch type {
//        case .insert:
//            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
//        case .delete:
//            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
//        default:
//            break
//        }
//    }
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        self.tableView.endUpdates()
//    }
//    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//}




