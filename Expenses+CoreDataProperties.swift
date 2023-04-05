//
//  Expenses+CoreDataProperties.swift
//  groceryCalculator
//
//  Created by Rahul Adepu on 4/4/23.
//
//

import Foundation
import CoreData


extension Expenses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expenses> {
        return NSFetchRequest<Expenses>(entityName: "Expenses")
    }

    @NSManaged public var category: String?
    @NSManaged public var consumedAmount: Double
    @NSManaged public var cost: Double
    @NSManaged public var storeName: String?
    @NSManaged public var purchasedDate: Date?
    @NSManaged public var id: String?

}

extension Expenses : Identifiable {

}
