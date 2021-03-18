//
//  Notebook+Extensions.swift
//  Mooskine
//
//  Created by Mehrdad on 2021-03-18.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Notebook {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
