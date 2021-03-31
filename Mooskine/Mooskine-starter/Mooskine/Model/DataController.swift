 //
//  DataController.swift
//  Mooskine
//
//  Created by Mehrdad on 2021-03-15.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation
import CoreData
 
 class DataController {
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    let persistentContainer: NSPersistentContainer
    
    var backgroundContext: NSManagedObjectContext!
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func configureContexts() {
        backgroundContext = persistentContainer.newBackgroundContext()
        
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error?.localizedDescription ?? "")
            }
            self.autoSaveViewContext()
            self.configureContexts()
            completion?()
        }
    }
    
 }
 
 extension DataController {
    func autoSaveViewContext(interval: TimeInterval = 30) {
        print("autosaving")
        guard interval > 0 else {
            print("cannot set negative autosave inerval")
            return
        }
        if viewContext.hasChanges {
           try? viewContext.save()
        }
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
 }
