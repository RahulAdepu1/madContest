//
//  Category+CoreDataProperties.swift
//  groceryCalculator
//
//  Created by Rahul Adepu on 4/4/23.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?

}

extension Category : Identifiable {

}
