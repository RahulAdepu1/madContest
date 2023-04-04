//
//  ExpensesView.swift
//  groceryCalculator
//
//  Created by Rahul Adepu on 4/4/23.
//

import SwiftUI
import Charts
import SwiftUICharts

struct ExpensesData:Identifiable {
    let id = UUID().uuidString
    let cost: Double
    var consumedAmount: Double
    var category: String
    var storeName: String
    var purchasedDate: Date
}

struct ExpensesView: View {
    
    let expenses:[ExpensesData] = [
        .init(cost: 4.95, consumedAmount: 1, category: "All", storeName: "Walmart", purchasedDate: Date.from(year: 2023, month: 1, day: 1)),
        .init(cost: 7.95, consumedAmount: 1, category: "Dairy", storeName: "Walmart", purchasedDate: Date.from(year: 2023, month: 2, day: 1)),
        .init(cost: 8.95, consumedAmount: 1, category: "Meat", storeName: "Walmart", purchasedDate: Date.from(year: 2023, month: 3, day: 1)),
        .init(cost: 7.95, consumedAmount: 1, category: "All", storeName: "Walmart", purchasedDate: Date.from(year: 2023, month: 4, day: 1)),
        .init(cost: 12.95, consumedAmount: 1, category: "All", storeName: "Walmart", purchasedDate: Date.from(year: 2023, month: 5, day: 1)),
        .init(cost: 5.95, consumedAmount: 1, category: "Dairy", storeName: "Walmart", purchasedDate: Date.from(year: 2023, month: 6, day: 1)),
        .init(cost: 7.95, consumedAmount: 1, category: "Meat", storeName: "Walmart", purchasedDate: Date.from(year: 2023, month: 7, day: 1)),
        .init(cost: 14.95, consumedAmount: 1, category: "Dairy", storeName: "Walmart", purchasedDate: Date.from(year: 2023, month: 8, day: 1)),
        .init(cost: 19.15, consumedAmount: 1, category: "Meat", storeName: "Walmart", purchasedDate: Date.from(year: 2023, month: 9, day: 1)),
        .init(cost: 7.95, consumedAmount: 1, category: "All", storeName: "Walmart", purchasedDate: Date.from(year: 2023, month: 10, day: 1)),
        .init(cost: 3.95, consumedAmount: 1, category: "Meat", storeName: "Walmart", purchasedDate: Date.from(year: 2023, month: 11, day: 1)),
        .init(cost: 7.95, consumedAmount: 1, category: "Meat", storeName: "Walmart", purchasedDate: Date.from(year: 2023, month: 12, day: 1)),
        
        
        .init(cost: 4.95, consumedAmount: 1, category: "All", storeName: "Kroger", purchasedDate: Date.from(year: 2023, month: 1, day: 2)),
        .init(cost: 7.95, consumedAmount: 1, category: "Dairy", storeName: "Kroger", purchasedDate: Date.from(year: 2023, month: 2, day: 2)),
        .init(cost: 8.95, consumedAmount: 1, category: "Meat", storeName: "Kroger", purchasedDate: Date.from(year: 2023, month: 3, day: 2)),
        .init(cost: 7.95, consumedAmount: 1, category: "All", storeName: "Kroger", purchasedDate: Date.from(year: 2023, month: 4, day: 2)),
        .init(cost: 12.95, consumedAmount: 1, category: "All", storeName: "Kroger", purchasedDate: Date.from(year: 2023, month: 5, day: 2)),
        .init(cost: 5.95, consumedAmount: 1, category: "Dairy", storeName: "Kroger", purchasedDate: Date.from(year: 2023, month: 6, day: 2)),
        .init(cost: 7.95, consumedAmount: 1, category: "Meat", storeName: "Kroger", purchasedDate: Date.from(year: 2023, month: 7, day: 2)),
        .init(cost: 14.95, consumedAmount: 1, category: "Dairy", storeName: "Kroger", purchasedDate: Date.from(year: 2023, month: 8, day: 2)),
        .init(cost: 19.15, consumedAmount: 1, category: "Meat", storeName: "Kroger", purchasedDate: Date.from(year: 2023, month: 9, day: 2)),
        .init(cost: 7.95, consumedAmount: 1, category: "All", storeName: "Kroger", purchasedDate: Date.from(year: 2023, month: 10, day: 2)),
        .init(cost: 3.95, consumedAmount: 1, category: "Meat", storeName: "Kroger", purchasedDate: Date.from(year: 2023, month: 11, day: 2)),
        .init(cost: 7.95, consumedAmount: 1, category: "Meat", storeName: "Kroger", purchasedDate: Date.from(year: 2023, month: 12, day: 2))
    ]
    
    @State var selectedElement: ExpensesData?
    
    var body: some View {
        //        let maxCost = round((expenses.map { $0.cost }.max() ?? 0) / 10 ) * 10
        VStack{
            Chart{
                ForEach(expenses) { expense in
                    BarMark(
                        x: .value("Month", expense.purchasedDate, unit: .month ),
                        y: .value("Cost", expense.cost)
                    )
                    .foregroundStyle(Color.red)
                }
                
            }
            .frame(height: 150)
            .padding(.bottom, 50)
            
            // By Store Name
            Chart{
                ForEach(expenses) { expense in
                    BarMark(
                        x: .value("Month", expense.purchasedDate, unit: .month ),
                        y: .value("Cost", expense.cost)
                    )
                    .foregroundStyle(by: .value("store", expense.storeName))
                }
                
            }
            .frame(height: 150)
            .chartXAxis {
                AxisMarks()
            }
            .padding(.bottom, 50)
            
            // By Category
            Chart{
                ForEach(expenses) { expense in
                    BarMark(
                        x: .value("Month", expense.category ),
                        y: .value("Cost", expense.cost)
                    )
                    .foregroundStyle(by: .value("cat", expense.category))
                }
                
            }
            .frame(height: 150)
            .chartXAxis {
                AxisMarks()
            }
            
        }
        .padding(20)
    }
}

struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesView()
    }
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}
