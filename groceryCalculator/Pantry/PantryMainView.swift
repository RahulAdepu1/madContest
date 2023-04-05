//
//  PantryMainView.swift
//  groceryCalculator
//
//  Created by Rahul Adepu on 4/3/23.
//

import SwiftUI

struct PantryMainView: View {
    
    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM
    
    var body: some View {
        ZStack {
            Color.clear
            VStack{
                HStack{
                    Button(action: {
                        listNameCoreDataVM.pantrySortList(by: .default)
                        listNameCoreDataVM.fetchPantry()
                    }) {
                        Text("Default")
                    }
                    .padding()

                    Button(action: {
                        listNameCoreDataVM.pantrySortList(by: .cost)
                        listNameCoreDataVM.fetchPantry()
                    }) {
                        Text("Cost")
                    }
                    .padding()
                }
                TextField("Search", text: $listNameCoreDataVM.pantrySearchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: listNameCoreDataVM.pantrySearchText) { _ in
                        listNameCoreDataVM.fetchPantry()
                    }
                
                // Check if the List is empty or not
                let pantry = listNameCoreDataVM.pantryCoreData
                if pantry.isEmpty {
                    ZStack {
                        Color.clear.ignoresSafeArea()
                        Text("Empty")
                    }
                }else {
                    VStack {
                        ScrollView{
                            ForEach(listNameCoreDataVM.pantryCoreData) { item in
                                pantryRowView(pantry: item)
                            }
                            
                        }.padding(.top, 30)
                    }
                    .background(Color.clear)
                }
                
            }
            
            
            
            
            
        }
        .navigationTitle("Pantry")
        .navigationBarTitleDisplayMode(.inline)
    }
}


//MARK: - Pantry Row View
struct pantryRowView: View {
    
    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM
    @StateObject var pantry: Pantry
    @State var detailSheet: Bool = false
    @State var finishedSheet: Bool = false
    
    
    var body: some View{
        
        HStack(alignment: .top){
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .foregroundColor(.black)
                .frame(width: 40, height: 40)
                .padding(10)
                .background(
                    Color.white
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                )
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            //                .padding(.leading, 10)
                .overlay(alignment: .bottomTrailing) {
                    Circle().fill(Color.white)
                        .frame(width: 30, height: 30)
                        .offset(x: 5, y: 5)
                        .overlay(alignment: .center) {
                            Text(String(format: "%.0f", pantry.count))
                                .font(pantry.count < 100 ? .body : .caption2)
                                .foregroundColor(.black)
                                .offset(x: 5, y: 5)
                        }
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                        
                }
            
            VStack(alignment: .leading) {
                Text(pantry.itemName ?? "UnKnown")
                    .font(.body)
                    .foregroundColor(Color.black)
                    .padding(.top, 1)
                Text(pantry.itemBrand ?? "")
                    .font(.subheadline)
                    .foregroundColor(Color.black)
                    .padding(.bottom, 1)
            }
            Spacer()
            VStack{
                expiryView(pantry: pantry)
            }
            .frame(width: 100)
        }
        .foregroundColor(.white.opacity(0.5))
        .padding(10)
        .frame(maxWidth: .infinity)
        .foregroundColor(Color.black)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 20)
        
        .onTapGesture(count: 1, perform: {
            detailSheet = true
        })
        .onLongPressGesture(minimumDuration: 0.1) {
            finishedSheet.toggle()
        }
        
        .sheet(isPresented: $detailSheet, content: {
            pantryItemDetailView(pantry: pantry)
                .presentationDetents([.medium])
        })
        .sheet(isPresented: $finishedSheet, content: {
            pantryItemFinishedView()
                .presentationDetents([.height(100)])
        })
        
    }
}

//MARK: - Pantry Item Detail View
struct pantryItemDetailView: View {
    
    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM
    @StateObject var pantry: Pantry
    @State var pantryItemEditSheet:Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View{
        VStack{
            pantryItemDetailIntro(pantry: pantry)
            Divider()
                .padding(.horizontal, 20)
            pantryItemDetailCondition(pantry: pantry, expiryDayReminder: 7)
            Divider()
                .padding(.horizontal, 20)
            pantryItemDetailLocCat(pantry: pantry)
            Divider()
                .padding(.horizontal, 20)
            pantryItemDetailExpStock(pantry: pantry)
            Divider()
                .padding(.horizontal, 20)
            HStack {
                Button {
                    pantryItemEditSheet = true
                } label: {
                    Text("Edit")
                        .modifier(CustomButtonDesign())
                }
                Button {
                    listNameCoreDataVM.deletePantryItem(pantry: pantry)
                    dismiss()
                } label: {
                    Text("Delete")
                        .modifier(CustomButtonDesign())
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .sheet(isPresented: $pantryItemEditSheet) {
            PantryItemEditView(pantry: pantry)
                .presentationDetents([.medium])
        }
    }
}

//MARK: - Pantry Item Finished or Delete Sheet
struct pantryItemFinishedView:View {
    @Environment(\.dismiss) var dismiss
    var body: some View{
        HStack{
            Button {
                dismiss()
            } label: {
                Text("Spoiled")
                    .modifier(CustomButtonDesign())
            }
            
            Button {
                dismiss()
            } label: {
                Text("Finished")
                    .modifier(CustomButtonDesign())
            }
        }
    }
}

//MARK: - Pantry Item Detail View - Intro
struct pantryItemDetailIntro: View {
    
    @StateObject var pantry: Pantry
    @Environment(\.dismiss) var dismiss
    
    var body: some View{
        HStack(alignment: .top) {
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
            VStack {
                Text(pantry.itemName ?? "")
                    .font(.title2)
                Text(pantry.itemBrand ?? "")
                    .font(.body)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Image(systemName: "multiply")
                    .fontWeight(.heavy)
                    .onTapGesture {
                        dismiss()
                    }
                    .padding(.bottom, 5)
                Text(String(format: "$%.2f", pantry.cost))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        
    }
}

//MARK: - Pantry Item Detail View - Condition
struct pantryItemDetailCondition: View {
    @StateObject var pantry: Pantry
    var expiryDayReminder: Int
    
    var body: some View{
        let dates = ExpiryDateCheck().expiryDateCheck(expiryDate: pantry.unwrappedExpiryDate)
        let totalDays = dates[0]
        
        HStack(spacing: 5){
            VStack(spacing:0){
                Text(totalDays > expiryDayReminder ? "Good" :
                        totalDays > 2 ? "Bad" : "Very Bad" )
                    .font(.headline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 2.5)
                    .background(totalDays > 8 ? Color.green.opacity(1) :
                                    totalDays > 2 ? Color.yellow.opacity(1) : Color.red.opacity(1))
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 0.1)
                            
                        )
                    .padding(.bottom, 6)
                Text("Status")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            VStack(spacing:0){
                CustomQuantityStepper(pantry: pantry, value: $pantry.count, stepValue: 1.0)
                Text("Quantity")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            VStack(spacing:0){
                CustomStepperConsumed(pantry: pantry, stepValue: 10.0)
                Text("remaining")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
}

//MARK: - Pantry Item Detail View - Date
struct pantryItemDetailExpStock: View {
    
    @StateObject var pantry: Pantry
    
    //Date Formatter
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yy"
        return formatter
    }()
    
    var body: some View{
        HStack{
            VStack{
                Text(dateFormatter.string(from: pantry.unwrappedStockedDate))
                    .font(.body)
                Text("Stocked on")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 10)
            VStack{
                Text(dateFormatter.string(from: pantry.unwrappedExpiryDate))
                    .font(.body)
                Text("Expires on")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 10)
        }
        .frame(maxWidth: .infinity)
        //        .background(Color.gray)
        .padding(.horizontal, 20)
    }
}

//MARK: - Pantry Item Detail View - Location & Category
struct pantryItemDetailLocCat: View {
    @StateObject var pantry: Pantry
    var body: some View{
        HStack{
            VStack{
                Text(pantry.location ?? "")
                    .font(.body)
                Text("Location")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)

            VStack{
                Text(pantry.storeName ?? "")
                    .font(.body)
                Text("Store")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            
            VStack{
                Text(pantry.category ?? "")
                    .font(.body)
                Text("Category")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        //        .background(Color.gray)
        .padding(.horizontal, 20)
        //
    }
}

//MARK: - Pantry Item Edit View
enum Sheets:Identifiable {
    case location
    case category
    
    var id: String { UUID().uuidString }
}

struct PantryItemEditView: View {
    
    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM
    @StateObject var pantry: Pantry
    @State var updatedStockedDate: Date = Date()
    @State var updatedExpiryDate: Date = Date()
    
    @State var newItemName: String = ""
    @State var newItemBrand: String = ""
    @State var newLocation: String = "Unkown"
    @State var newCategory: String = "None"
    
    @State var itemNameChanged: Bool = false
    @State var itemBrandChanged: Bool = false
    @State var stockedDateChanged: Bool = false
    @State var expiryDateChanged: Bool = false
    
    var LocationList: [String] = ["Frezer","Fridge", "Kitchen Closet", "Chicken Shelf"]
    
    @State private var activeSheet: Sheets?
    
    @Environment(\.dismiss) var dismiss
    var body: some View{
        VStack{
            // Text Fields to change the Title Name and Brand Name
            HStack{
                TextField("Item Name", text: $newItemName)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: newItemName) { newValue in
                        itemNameChanged = true
                    }
                TextField("Item Brand", text: $newItemBrand)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: newItemBrand) { newValue in
                        itemBrandChanged = true
                    }
            }
            
            // Date Picker to change the
            DatePicker("Stocked Date", selection: $updatedStockedDate, displayedComponents: [.date])
                .onChange(of: updatedStockedDate) { newValue in
                    stockedDateChanged = true
                }
            
            DatePicker("Expiry Date", selection: $updatedExpiryDate, displayedComponents: [.date])
                .onChange(of: updatedExpiryDate) { newValue in
                    expiryDateChanged = true
                }
            
            // Open a new sheet to choose Location Choice or add a new location
            HStack{
                Text("Location")
                Spacer()
                Button {
                    activeSheet = .location
                } label: {
                    Text("Location")
                        .foregroundColor(Color.black)
                }
            }
            .padding(.vertical, 8)
            
            HStack{
                Text("Category")
                Spacer()
                Button {
                    activeSheet = .category
                } label: {
                    Text("Category")
                        .foregroundColor(Color.black)
                }
            }
            .padding(.vertical, 8)
            
            Button {
                if stockedDateChanged{
                    listNameCoreDataVM.updatePantryStockedDate(newPantryItems: pantry, pantryStockedDate: updatedStockedDate)
                }
                if expiryDateChanged{
                    listNameCoreDataVM.updatePantryExpiryDate(newPantryItems: pantry, pantryExpiryDate: updatedExpiryDate)
                }
                if itemNameChanged{
                    listNameCoreDataVM.updatePantryItemName(newPantryItems: pantry, pantryItemName: newItemName)
                }
                if itemBrandChanged{
                    listNameCoreDataVM.updatePantryItemBrand(newPantryItems: pantry, pantryItemBrand: newItemBrand)
                }
                dismiss()
            } label: {
                Text("Done")
                    .modifier(CustomButtonDesign())
            }
        }
        .padding(20)
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .location:
                LocationEditView()
                    .presentationDetents([.medium])
            case .category:
                CategoryEditView()
                    .presentationDetents([.medium])
            }
        }
    }
}


//MARK: - Edit Location Picker View Sheet
struct LocationEditView:View {
    var body: some View{
        Text("Location Edit")
    }
}

//MARK: - Edit Category Picker View Sheet
struct CategoryEditView:View {
    var body: some View{
        Text("Category Edit")
    }
}

//MARK: - Custom Textfield Design
struct CustomTextField: View {
    
    @State private var offset: CGFloat = 1
    @State private var scaleEffect: CGFloat = 0
    @State private var color: Color = .gray.opacity(0.3)
    var placeholderText: String
    @Binding var text: String
    var keyboardType: UIKeyboardType
    
    var body: some View{
        ZStack(alignment: .leading) {
            Text(placeholderText)
                .padding(10)
                .foregroundColor(text.isEmpty ? color : color)
                .offset(x: 0, y: text.isEmpty ? offset : offset)
                .scaleEffect(text.isEmpty ? scaleEffect : scaleEffect, anchor: .leading)
            TextField(placeholderText+" ", text: $text)
                .padding(10)
                .foregroundColor(color)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black.opacity(0.3))
                )
                .keyboardType(keyboardType)
                .lineLimit(2)
        }
        .padding(.top, 15)
        .onChange(of: text) { newValue in
            withAnimation(.easeInOut) {
                if text.isEmpty{
                    color = .gray.opacity(0.3)
                    offset = 0
                    scaleEffect = 1
                }else{
                    color = Color.white.opacity(0.5)
                    offset = -34
                    scaleEffect = 0.8
                }
            }
        }
    }
}

//MARK: - Custom Button Design
struct CustomButtonDesign: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 5)
        
        
    }
}

//MARK: - Expiry Date Check Logic
struct ExpiryDateCheck {
    
    func expiryDateCheck(expiryDate: Date) -> [Int]{
        let components = Calendar.current.dateComponents([.day], from: Date(), to: expiryDate)
        let totalDays = components.day! + 1
        var days = 0
        var weeks = 0
        
        if totalDays > 7 {
            weeks = totalDays / 7
            days = totalDays % 7
        }
        return [totalDays, days, weeks]
    }
}

//MARK: - Expiry View
struct expiryView: View {
    
    @StateObject var pantry: Pantry
    
    var body: some View{
        VStack {
            let dates = ExpiryDateCheck().expiryDateCheck(expiryDate: pantry.unwrappedExpiryDate)
            let totalDays = dates[0]
            let days = dates[1]
            let weeks = dates[2]
            
            if totalDays < 0 {
                Text("Expired")
            }else if totalDays == 0 {
                Text("Expires")
                    .font(.caption)
                Text("Today")
                    .font(.title2)
                
                // Last 7 days
            }else if (totalDays < 7 && weeks == 0) {
                Text("Expires in")
                    .font(.caption)
                Text(totalDays == 1 ? "\(totalDays) Day" : "\(totalDays) Days")
                    .font(.title2)
                
                // Last 1 week
            }else if (totalDays == 7 && weeks == 0) {
                Text("Expires in")
                    .font(.caption)
                Text("1 Wk")
                    .font(.title2)
            }else if (weeks > 0 && days == 0) {
                Text("Expires in")
                    .font(.caption)
                Text(weeks == 1 ? "\(weeks) Wk" : "\(weeks) Wks" )
                    .font(.title2)
                Text(days == 1 ? "\(days) Day" : "\(days) Days")
                    .font(.body)
            }else if (weeks > 0 && days > 0) {
                Text("Expires in")
                    .font(.caption)
                Text(weeks == 1 ? "\(weeks) Wk" : "\(weeks) Wks" )
                    .font(.title2)
                Text(days == 1 ? "\(days) Day" : "\(days) Days")
                    .font(.body)
            }
        }
        .foregroundColor(Color.black)
    }
}


//MARK: - Custom Stepper View
struct CustomQuantityStepper: View {
    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM
    @StateObject var pantry: Pantry
    @Binding var value: Double
    @State var stepValue: Double
    
    @State private var count = 0
    @State private var isAlert: Bool = false
    
    var body: some View {
        HStack(spacing: 5) {
            Button(action: {
                if value > 1 {
                    value -= stepValue
                }else {
                    isAlert = true
                }
            }) {
                Image(systemName: "minus")
                    .resizable()
                    .foregroundColor(Color.orange)
                    .frame(width: 10, height: 2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 10)
                    .cornerRadius(5)
                
            }
            Text(String(format: "%.0f", value))
                .font(.title3)
                .fontWeight(.bold)
            Button(action: {
                if value < 10000 {
                    value += stepValue
                }
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .foregroundColor(Color.orange)
                    .frame(width: 15, height: 15)
                    .padding(.horizontal, 5.5)
                    .padding(.vertical, 3.5)
                    .cornerRadius(5)
            }
        }
        .foregroundColor(Color.black)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
        .padding(.bottom, 6)
        .alert("Count reached zero", isPresented: $isAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                
                //Add the item to History
                
                
                //Delete the item from pantry
                listNameCoreDataVM.deletePantryItem(pantry: pantry)
            }
        } message: {
            Text("If you have finished the item \nthen Click on Delete")
        }
    }
}

//MARK: - Custom Stepper Consumed
struct CustomStepperConsumed: View {
    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM
    @StateObject var pantry: Pantry
    //    @Binding var pantry.consumedAmount: Double
    @State var stepValue: Double
    
    @State private var isAlert: Bool = false
    
    
    var body: some View {
        HStack(spacing: 5) {
            Button(action: {
                if pantry.remainingAmount > 10 {
                    pantry.remainingAmount -= stepValue
                } else if pantry.count > 1 {
                    pantry.count -= 1.0
                    pantry.remainingAmount = 100.0
                } else {
                    isAlert = true
                }
            }) {
                Image(systemName: "minus")
                    .resizable()
                    .foregroundColor(Color.orange)
                    .frame(width: 10, height: 2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 10)
                    .cornerRadius(5)
            }
            
            Text(String(format: "%.0f%%", (pantry.remainingAmount)))
                .padding(.vertical, 5)
                .font(.subheadline)
                .fontWeight(.bold)
            Button(action: {
                if pantry.remainingAmount < 100.0 {
                    pantry.remainingAmount += stepValue
                } else {
                    pantry.count += 1.0
                    pantry.remainingAmount = 10.0
                }
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .foregroundColor(Color.orange)
                    .frame(width: 15, height: 15)
                    .padding(.horizontal, 5.5)
                    .padding(.vertical, 3.5)
                    .cornerRadius(5)
            }
        }
        .foregroundColor(Color.black)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
        .padding(.bottom, 6)
        .alert("Count reached zero", isPresented: $isAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                
                //Add the item to History
                
                
                //Delete the item from pantry
                listNameCoreDataVM.deletePantryItem(pantry: pantry)
            }
        } message: {
            Text("If you have finished the item \nthen Click on Delete")
        }
    }
    
    func showAlert() {
        
    }
}


//MARK: - Preview Section

struct PantryMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            PantryMainView()
        }
        .environmentObject(ListNameCoreDataVM())
    }
}
