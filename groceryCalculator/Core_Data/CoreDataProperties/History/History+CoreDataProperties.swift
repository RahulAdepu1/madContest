//
//  History+CoreDataProperties.swift
//  groceryCalculator
//
//  Created by Rahul Adepu on 4/4/23.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var count: Double
    @NSManaged public var cost: Double
    @NSManaged public var storeName: String?
    @NSManaged public var purchaseType: String?
    @NSManaged public var itemName: String?
    @NSManaged public var itemBrand: String?
    @NSManaged public var id: String?
    @NSManaged public var purchaseDate: Date?

}

extension History : Identifiable {

}
