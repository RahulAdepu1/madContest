//
//  groceryCalculatorApp.swift
//  groceryCalculator
//
//  Created by Rahul Adepu on 4/3/23.
//

import SwiftUI

@main
struct groceryCalculatorApp: App {
    @StateObject var listNameCoreDataVM: ListNameCoreDataVM = ListNameCoreDataVM()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ShoppingListMainView()
            }
            .environmentObject(listNameCoreDataVM)
        }
    }
}
