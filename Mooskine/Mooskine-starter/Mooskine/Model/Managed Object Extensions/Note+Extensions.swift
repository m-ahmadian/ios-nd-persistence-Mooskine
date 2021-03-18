//
//  Note+Extensions.swift
//  Mooskine
//
//  Created by Mehrdad on 2021-03-18.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Note {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
