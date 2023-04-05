//
//  Pantry+CoreDataProperties.swift
//  groceryCalculator
//
//  Created by Rahul Adepu on 4/3/23.
//
//

import Foundation
import CoreData


extension Pantry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pantry> {
        return NSFetchRequest<Pantry>(entityName: "Pantry")
    }

    @NSManaged public var id: String?
    @NSManaged public var itemName: String?
    @NSManaged public var itemBrand: String?
    @NSManaged public var category: String?
    @NSManaged public var location: String?
    @NSManaged public var storeName: String?
    @NSManaged public var purchaseType: String?
    @NSManaged public var count: Double
    @NSManaged public var cost: Double
    @NSManaged public var stockedDate: Date?
    @NSManaged public var expiryDate: Date?
    @NSManaged public var consumedDate: Date?
    @NSManaged public var consumedAmount: Double
    @NSManaged public var remainingAmount: Double
    
    public var unwrappedConsumedDate: Date {
        let date = consumedDate ?? Date()
        return date
    }
    public var unwrappedExpiryDate: Date {
        let date = expiryDate ?? Date()
        return date
    }
    public var unwrappedStockedDate: Date {
        let date = stockedDate ?? Date()
        return date
    }
    
    public var unwrappedItemName: String { itemName ?? "" }
    public var unwrappedItemBrand: String { itemBrand ?? "" }
    public var unwrappedCategory: String { category ?? "All" }
    public var unwrappedLocation: String { location ?? "Unknown" }
    public var unwrappedStoreName: String { storeName ?? "" }
    public var unwrappedPurchaseType: String { purchaseType ?? "" }
    
}

extension Pantry : Identifiable {

}
