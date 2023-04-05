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
        if context.hasChanges {
            do {
                try context.save()
                print("Saved sucessfully")
            } catch let error {
                print("Error saving Core Data. \(error.localizedDescription)")
            }
        }
    }
    
}

//MARK: - List Name Core Data View Model
class ListNameCoreDataVM: ObservableObject {
    
    let manager = CoreDataManager.instance
    
    let listNameEntity: String = "ListName"
    let listItemEntity: String = "ListItem"
    let pantryEntity: String = "Pantry"
    let historyEntity: String = "History"
    let expensesEntity: String = "Expenses"
    
    @Published var listNameCoreData: [ListName] = []
    @Published var listItemsCoreData: [ListItem] = []
    @Published var pantryCoreData: [Pantry] = []
    @Published var historyCoreData: [History] = []
    @Published var expensesCoreData: [Expenses] = []
    
    @Published var stillLookingItemsArray: [ListItem] = []
    @Published var foundItemsArray: [ListItem] = []
    @Published var notFoundItemsArray: [ListItem] = []
    
    // Sort Function for History View
    @Published var historySearchText: String = ""
    @Published var historySortOption: HistorySortOption = .default
    enum HistorySortOption {
        case `default`
        case store
        case cost
    }
    
    //Seacrh Box and Sort Function for Pantry
    @Published var pantrySearchText: String = ""
    @Published var pantrySortOption: PantrySortOption = .default
    @Published var pantryAscending: Bool = true
    enum PantrySortOption {
        case `default`
        case cost
        case date
    }
    
    // Initialize ListItems
    init() {
//        whereIsMySQLite()
        fetchListName()
        fetchListItems()
        fetchPantry()
        fetchHistory()
        fetchExpenses()
        
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
//        let request = NSFetchRequest<ListName>(entityName: listNameEntity)
        //Another way to get fetch data
        let request: NSFetchRequest<ListName> = ListName.fetchRequest()
        
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
        let requestPantry = NSFetchRequest<Pantry>(entityName: pantryEntity)
        requestPantry.sortDescriptors = sortPantryDescriptor()
        
        // For Search Bar
        if !pantrySearchText.isEmpty {
            requestPantry.predicate = NSPredicate(format: "itemName CONTAINS[c] %@", pantrySearchText)
        }
        
        do {
            pantryCoreData = try manager.context.fetch(requestPantry)
        }catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func fetchHistory() {
        let requestHistory = NSFetchRequest<History>(entityName: historyEntity)
        requestHistory.sortDescriptors = sortHistoryDescriptor()
        
        // For Search Bar
        if !historySearchText.isEmpty {
            requestHistory.predicate = NSPredicate(format: "itemName CONTAINS[c] %@", historySearchText)
        }
        
        // Try to fetch Data
        do {
            historyCoreData = try manager.context.fetch(requestHistory)
        }catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func fetchExpenses() {
        let request = NSFetchRequest<Expenses>(entityName: expensesEntity)
        do {
            expensesCoreData = try manager.context.fetch(request)
        }catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }

//------------------------------------------------------------------------------------------------------------------------
    
    // Sort Function for Pantry
    func sortPantryDescriptor() -> [NSSortDescriptor] {
        
        let sortByItemName = NSSortDescriptor(keyPath: \Pantry.itemName, ascending: pantryAscending)
        let sortByCost = NSSortDescriptor(keyPath: \Pantry.cost, ascending: pantryAscending)
        let sortByExpiryDate = NSSortDescriptor(keyPath: \Pantry.expiryDate, ascending: pantryAscending)
        
        switch pantrySortOption {
        case .default:
            return [sortByItemName]
        case .cost:
            return [sortByCost]
        case .date:
            return [sortByExpiryDate]
        }
    }
    
    func togglePantrySortOrder() {
        pantryAscending.toggle()
        fetchPantry()
    }
    
    func pantrySortList(by sortOrder: PantrySortOption) {
        if sortOrder == self.pantrySortOption {
            pantryAscending.toggle()
        } else {
            self.pantrySortOption = sortOrder
            pantryAscending = true
        }
        fetchPantry()
    }
    
    // Sort Function for History
    func sortHistoryDescriptor() -> [NSSortDescriptor] {
        
        let sortByDate = NSSortDescriptor(keyPath: \History.purchaseDate, ascending: true)
        let sortByStoreName = NSSortDescriptor(keyPath: \History.storeName, ascending: false)
        let sortByCost =  NSSortDescriptor(keyPath: \History.cost, ascending: true)
        
        switch historySortOption {
        case .default:
            return [sortByDate]
        case .store:
            return [sortByDate, sortByStoreName]
        case .cost:
            return [sortByCost]
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
    func addPantry(itemName: String, itemBrand: String = "", itemCount: Double, itemCost: Double, storeName: String, purchaseType: String) {
        let newPantryItems = Pantry(context: manager.context)
        newPantryItems.id = UUID().uuidString
        newPantryItems.itemName = itemName
        newPantryItems.itemBrand = itemBrand
        newPantryItems.category = "All"
        newPantryItems.location = "Unknown"
        newPantryItems.storeName = storeName
        newPantryItems.purchaseType = purchaseType
        newPantryItems.count = itemCount
        newPantryItems.cost = itemCost
        newPantryItems.stockedDate = Date()
        newPantryItems.expiryDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        newPantryItems.consumedDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        newPantryItems.consumedAmount = 0.0
        newPantryItems.remainingAmount = 100.0
        save()
    }
    
    // Add History
    func addHistory(itemName: String, itemBrand: String = "", itemCount: Double, itemCost: Double, storeName: String, purchaseType: String) {
        let newHistory = History(context: manager.context)
        newHistory.id = UUID().uuidString
        newHistory.itemName = itemName
        newHistory.itemBrand = itemBrand
        newHistory.storeName = storeName
        newHistory.purchaseType = purchaseType
        newHistory.cost = itemCost
        newHistory.count = itemCount
        newHistory.purchaseDate = Date()
        }
    
    // Add Expenses
    func addExpenses(storeName: String, category: String, cost: Double, consumedAmount: Double, purchasedDate: Date){
        let newExpenses = Expenses(context: manager.context)
        newExpenses.id = UUID().uuidString
        newExpenses.storeName = storeName
        newExpenses.category = category
        newExpenses.cost = cost
        newExpenses.consumedAmount = consumedAmount
        newExpenses.purchasedDate = purchasedDate
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
    // Updating Data of Expenses
    func updateConsumedAmount(newExpenseConsumedAmount: Expenses, consumedAmount: Double){
        newExpenseConsumedAmount.consumedAmount = consumedAmount
        save()
    }
    
//------------------------------------------------------------------------------------------------------------------------
    func save() {
        manager.save()
        fetchListName()
        fetchListItems()
        
        foundItems()
        notFoundItems()
        
        //To reload Pantry
        fetchPantry()
    }
}
