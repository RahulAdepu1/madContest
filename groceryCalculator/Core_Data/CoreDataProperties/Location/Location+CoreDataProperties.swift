//
//  Location+CoreDataProperties.swift
//  groceryCalculator
//
//  Created by Rahul Adepu on 4/4/23.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?

}

extension Location : Identifiable {

}
