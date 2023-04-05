//
//  ExpensesView.swift
//  groceryCalculator
//
//  Created by Rahul Adepu on 4/4/23.
//

import SwiftUI
import Charts

struct ExpensesView: View {
    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM
    
    var body: some View {
        NavigationStack{
            TabView{
                ExpensesChartView()
//                CategoryChartView()
//                StoreChartView()
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
        }
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

struct ExpensesChartView:View {
    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM

    var body: some View{
        VStack{
            Chart{
                ForEach(listNameCoreDataVM.pantryCoreData) { pantry in
                    BarMark(
                        x: .value("Month", pantry.unwrappedStockedDate, unit: .month ),
                        y: .value("Cost", pantry.cost)
                    )
                    .foregroundStyle(Color.red)
                }
                
            }
            .frame(height: 150)
            .padding(.bottom, 50)
        }
    }
}

//struct CategoryChartView:View {
//    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM
//    var body: some View{
//        VStack{
//            Chart{
//                ForEach(listNameCoreDataVM.pantryCoreData) { pantry in
//                    BarMark(
//                        x: .value("Month", pantry.unwrappedStockedDate, unit: .month ),
//                        y: .value("Cost", pantry.cost)
//                    )
//                    .foregroundStyle(by: .value("store", pantry.unwrappedStoreName))
//                }
//
//            }
//            .frame(height: 150)
//            .chartXAxis {
//                AxisMarks()
//            }
//            .padding(.bottom, 50)
//        }
//    }
//}
//
//struct StoreChartView:View {
//    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM
//    var body: some View{
//        Chart{
//            ForEach(listNameCoreDataVM.pantryCoreData) { pantry in
//                BarMark(
//                    x: .value("Month", pantry.unwrappedStockedDate, unit: .month ),
//                    y: .value("Cost", pantry.cost)
//                )
//                .foregroundStyle(by: .value("cat", pantry.unwrappedCategory))
//            }
//
//        }
//        .frame(height: 150)
//    }
//}
