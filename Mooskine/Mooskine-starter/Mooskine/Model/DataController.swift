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
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
 }
