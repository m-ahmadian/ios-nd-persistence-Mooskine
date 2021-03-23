//
//  ListDataSource.swift
//  Mooskine
//
//  Created by Mehrdad on 2021-03-22.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ListDataSource<ObjectType: NSManagedObject, CellType: UITableViewCell>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var fetchRequest: NSFetchRequest<ObjectType>!
    
    var fetchedResultsController: NSFetchedResultsController<ObjectType>!
    
    var configure: (CellType, ObjectType) -> Void
    
    init(tableView: UITableView, managedObjectContext: NSManagedObjectContext, fetchRequest: NSFetchRequest<ObjectType>, configure: @escaping (CellType, ObjectType) -> Void) {
        
        self.tableView = tableView
        self.managedObjectContext = managedObjectContext
        self.fetchRequest = fetchRequest
        self.configure = configure
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            delete(at: indexPath)
        default:
            () //
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let anObject = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CellType.self)", for: indexPath) as! CellType
        
        // Configure cell
        configure(cell, anObject)
        
        return cell
    }
    
    // Helper Methods
    func delete(at indexPath: IndexPath) {
        let objectToDelete = fetchedResultsController.object(at: indexPath)
        managedObjectContext.delete(objectToDelete)
        try? managedObjectContext.save()
    }
    
    func addNotebook(name: String) {
        let notebook = Notebook(context: managedObjectContext)
        notebook.name = name
        try? managedObjectContext.save()
        
    }
    
    func addNote(notebook: Notebook) {
        let note = Note(context: managedObjectContext)
        note.text = "New Note"
        note.notebook = notebook
        try? managedObjectContext.save()
        
    }
    
    
    
    
    // Mark: - NSFetchedResultsControllerDelegate Methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
        case .move, .update:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
}
