//
//  ListName+CoreDataProperties.swift
//  groceryCalculator
//
//  Created by Rahul Adepu on 4/3/23.
//
//

import Foundation
import CoreData


extension ListName {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListName> {
        return NSFetchRequest<ListName>(entityName: "ListName")
    }
    
    @NSManaged public var id: String?
    @NSManaged public var date: Date?
    @NSManaged public var listName: String?
    @NSManaged public var items: NSSet?
    
    public var unwrappedlistName: String {
        listName ?? "Unknown name"
    }
    
    public var itemsArray: [ListItem] {
        let itemsSet = items as? Set<ListItem> ?? []
        
        return itemsSet.sorted {
            $0.unwrappeditemName < $1.unwrappeditemName
        }
    }
    
    public var myDate: Date {
        let myDate = date ?? Date()
        return myDate
    }
}

// MARK: Generated accessors for items
extension ListName {
    
    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ListItem)
    
    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ListItem)
    
    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)
    
    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)
    
}

extension ListName : Identifiable {
    
}
