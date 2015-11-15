//
//  ShopList+CoreDataProperties.swift
//  ListApp
//
//  Created by Suruchi on 14/11/2015.
//  Copyright © 2015 BAPAT. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension ShopList {

    @NSManaged var listname: String?
    @NSManaged var store: String?
    @NSManaged var category: String?
    @NSManaged var buyitems: NSSet?

}
