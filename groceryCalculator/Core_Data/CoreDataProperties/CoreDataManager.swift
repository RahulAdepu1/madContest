//
//  CoreDataManager.swift
//  groceryCalculator
//
//  Created by Rahul Adepu on 4/3/23.
//

import Foundation

import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    let containerName: String = "CoreDataModel"
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data. \(error.localizedDescription)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            if context.hasChanges {
                try context.save()
                print("Saved sucessfully")
            }
        } catch let error {
            print("Error saving Core Data. \(error.localizedDescription)")
        }
    }
    
}

//MARK: - List Name Core Data View Model
class ListNameCoreDataVM: ObservableObject {
    
    let manager = CoreDataManager.instance
    
    let listNameEntity: String = "ListName"
    let listItemEntity: String = "ListItem"
    let pantryEntity: String = "Pantry"
    @Published var listNameCoreData: [ListName] = []
    @Published var listItemsCoreData: [ListItem] = []
    @Published var pantryCoreData: [Pantry] = []
    
    @Published var stillLookingItemsArray: [ListItem] = []
    @Published var foundItemsArray: [ListItem] = []
    @Published var notFoundItemsArray: [ListItem] = []
    
    // Initialize ListItems
    init() {
        whereIsMySQLite()
        fetchListName()
        fetchListItems()
        fetchPantry()
        
//        stillLookingItems()
        foundItems()
        notFoundItems()
    }
    
    //Find Database Location
    func whereIsMySQLite() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
        print(path ?? "Not found")
    }
    
//------------------------------------------------------------------------------------------------------------------------
    // Fetech all the List Items from core data
    func fetchListName() {
        let request = NSFetchRequest<ListName>(entityName: listNameEntity)
        //Another way to get fetch data
        //let request: NSFetchRequest<ListName> = ListName.fetchRequest()
        
        do {
            listNameCoreData = try manager.context.fetch(request)
        }catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func fetchListItems() {
        let request = NSFetchRequest<ListItem>(entityName: listItemEntity)
        do {
            listItemsCoreData = try manager.context.fetch(request)
        }catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func fetchPantry() {
        let request = NSFetchRequest<Pantry>(entityName: pantryEntity)
        do {
            pantryCoreData = try manager.context.fetch(request)
        }catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
//------------------------------------------------------------------------------------------------------------------------
    // Add List Name
    func addListName(inputListName: String) {
        let newListName = ListName(context: manager.context)
        newListName.id = UUID().uuidString
        newListName.date = Date()
        newListName.listName = inputListName
        save()
    }
    
    // Add List Item
    func addListItem(inputListItem: String, listName: ListName) {
        let newListItem = ListItem(context: manager.context)
        newListItem.id = UUID().uuidString
        newListItem.itemName = inputListItem
        newListItem.itemCount = 1.0
        newListItem.isLooking = false
        newListItem.isFound = false
        listName.addToItems(newListItem)
        save()
    }
    
    // Add Pantry Items
    func addPantry(itemName: String, itemCount: Double) {
        let newPantryItems = Pantry(context: manager.context)
        newPantryItems.id = UUID().uuidString
        newPantryItems.itemName = itemName
        newPantryItems.itemBrand = ""
        newPantryItems.category = "None"
        newPantryItems.location = "Unknown"
        newPantryItems.storeName = "None"
        newPantryItems.purchaseType = "None"
        newPantryItems.count = itemCount
        newPantryItems.cost = 0.0
        newPantryItems.stockedDate = Date()
        newPantryItems.expiryDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        newPantryItems.consumedDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        newPantryItems.consumedAmount = 0.0
        newPantryItems.remainingAmount = 100.0
        save()
    }
//------------------------------------------------------------------------------------------------------------------------
    // Delete List Name
    func deleteListName(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let listNameCoreData = listNameCoreData[index]
        manager.context.delete(listNameCoreData)
        save()
    }
    
    // Delete List Item
    func deleteListItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let listItemsCoreData = listItemsCoreData[index]
        manager.context.delete(listItemsCoreData)
        save()
    }
    
    // Delete List Item
//    func deletePantryItem(indexSet: IndexSet) {
//        guard let index = indexSet.first else { return }
//        let pantryCoreData = pantryCoreData[index]
//        manager.context.delete(pantryCoreData)
//        save()
//    }
    func deletePantryItem(pantry: Pantry) {
        manager.context.delete(pantry)
        save()
    }
    
//------------------------------------------------------------------------------------------------------------------------
    func stillLookingItems() -> [ListItem]{
        return listNameCoreData.flatMap{ $0.itemsArray.filter{ !$0.isLooking && !$0.isFound } }
    }
    
    func foundItems(){
        fetchListName()
        foundItemsArray = listNameCoreData.flatMap{ $0.itemsArray.filter{ $0.isLooking && $0.isFound } }
    }
    
    func notFoundItems(){
        notFoundItemsArray = listNameCoreData.flatMap{ $0.itemsArray.filter{ $0.isLooking && !$0.isFound } }
    }
//------------------------------------------------------------------------------------------------------------------------
    // Updating Boolen Conditions
    func updateIsLooking(listItemsCoreData: ListItem){
        listItemsCoreData.isLooking = false
        listItemsCoreData.isFound = false
        save()
    }
    
    func updateIsFound(listItemsCoreData: ListItem){
        listItemsCoreData.isLooking = true
        listItemsCoreData.isFound = true
        save()
    }
    
    func updateIsNotFound(listItemsCoreData: ListItem){
        listItemsCoreData.isLooking = true
        listItemsCoreData.isFound = false
        save()
    }
    
//------------------------------------------------------------------------------------------------------------------------
    // Updating Data of Items Pantry
    func updatePantryItemName(newPantryItems: Pantry, pantryItemName: String){
        newPantryItems.itemName = pantryItemName
        save()
    }
    
    func updatePantryItemBrand(newPantryItems: Pantry, pantryItemBrand: String){
        newPantryItems.itemBrand = pantryItemBrand
        save()
    }
    
    func updatePantryCategory(newPantryItems: Pantry, pantryCategory: String){
        newPantryItems.category = pantryCategory
        save()
    }
    
    func updatePantryLocation(newPantryItems: Pantry, pantryLocation: String){
        newPantryItems.location = pantryLocation
        save()
    }
    
    func updatePantryItemCount(newPantryItems: Pantry, pantryItemCount: Double){
        newPantryItems.count = pantryItemCount
        save()
    }
    
    func updatePantryItemCost(newPantryItems: Pantry, pantryItemCost: Double){
        newPantryItems.cost = pantryItemCost
        save()
    }
    
    func updatePantryStockedDate(newPantryItems: Pantry, pantryStockedDate: Date){
        newPantryItems.stockedDate = pantryStockedDate
        save()
    }
    
    func updatePantryExpiryDate(newPantryItems: Pantry, pantryExpiryDate: Date){
        newPantryItems.expiryDate = pantryExpiryDate
        save()
    }
    
    func updatePantryConsumenDate(newPantryItems: Pantry, pantryConsumenDate: Date){
        newPantryItems.consumedDate = pantryConsumenDate
        save()
    }
    
//------------------------------------------------------------------------------------------------------------------------
    func save() {
        manager.save()
        fetchListName()
        fetchListItems()
        
        foundItems()
        notFoundItems()
        
        
        fetchPantry()
    }
}
