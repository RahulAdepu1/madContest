//
//  ShoppingListView.swift
//  groceryCalculator
//
//  Created by Rahul Adepu on 4/3/23.
//

import SwiftUI

struct ShoppingListMainView: View {
    
    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM
    @State var sheetShow: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            Color.clear
            let listName = listNameCoreDataVM.listNameCoreData
            if listName.isEmpty {
                ZStack {
                    Color.gray.ignoresSafeArea()
                    Text("Empty")
                }
            }else {
                ZStack {
                    List{
                        ForEach(listNameCoreDataVM.listNameCoreData) { listName in
                            NavigationLink {
                                // Navigation VIEW --------------------------------------------------------------------------------
                                ListItemView(listNameCoreData: listName)
                            } label: {
                                // Each Row of List Name VIEW ---------------------------------------------------------------------
                                ListNameRowView(listName: listName)
                                    .onLongPressGesture {
                                        print("Long Pressed \(listName.unwrappedlistName)")
                                    }
                            }
                        }
                        .onDelete(perform: listNameCoreDataVM.deleteListName)
                    }
                }
            }
            Button {
                sheetShow.toggle()
            } label: {
                Image(systemName: "plus")
                    .font(.headline)
                    .foregroundColor(Color.black)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .foregroundColor(Color.orange)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 10)
            }
            .padding(50)
            
        }
        .sheet(isPresented: $sheetShow) {
            //Add List Name Sheet Show VIEW --------------------------------------------------------------------------------------
            AddListNameSheetShow()
        }
        .navigationTitle("ListName")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Add New List Name Sheet View
struct AddListNameSheetShow: View {
    
    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM
    @State var inputTextName: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View{
        VStack {
            TextField("Add List Name", text: $inputTextName)
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color.gray)
                .cornerRadius(10)
                .padding( 20)
            HStack {
                Button {
                    if !inputTextName.isEmpty{
                        listNameCoreDataVM.addListName(inputListName: inputTextName)
                    }
                    dismiss()
                } label: {
                    Text("Done")
                        .padding(.vertical, 10)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .padding(.vertical, 10)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
            }
        }
        .presentationDetents([.height(200)])
    }
}


// MARK: - List Name Row View
struct ListNameRowView: View {
    
    @State var listName: ListName
    
    //Date Formatter
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yy"
        return formatter
    }()
    
    var body: some View{
        HStack {
            Text(listName.listName ?? "")
            Spacer()
            Text(dateFormatter.string(from: listName.myDate))
                .font(.caption)
        }
    }
}

struct dateModify{
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yy"
        return formatter
    }()
}


// MARK: - List Item View
struct ListItemView: View {
    
    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM
    @StateObject var listNameCoreData: ListName
    
    //    var stillLookingItems: [Binding<ListItem>] {
    //        $listNameCoreDataVM.stillLookingItemsArray.filter{ !$0.isLooking.wrappedValue && !$0.isFound.wrappedValue}
    //    }
    //
    //    var foundItems: [Binding<ListItem>] {
    //        $listNameCoreDataVM.foundItemsArray.filter{ $0.isLooking.wrappedValue && $0.isFound.wrappedValue}
    //    }
    //
    //    var notFoundItems: [Binding<ListItem>] {
    //        $listNameCoreDataVM.notFoundItemsArray.filter{ $0.isLooking.wrappedValue && !$0.isFound.wrappedValue}
    //    }
    
    @State var sheetShow: Bool = false
    @State var addSheetShow: Bool = false
    @State var everythingChecked: Bool = false
    
    var body: some View{
        
        ZStack(alignment: .bottomTrailing) {
            List{
                ForEach(listNameCoreData.itemsArray) { listItem in
                    if (!listItem.isLooking && !listItem.isFound) {
                        ListItemRowView(listItem: listItem)
                    }
                }
                .onDelete(perform: deleteListItem)
                
                ForEach(listNameCoreData.itemsArray) { listItem in
                    if (listItem.isLooking && listItem.isFound) {
                        ListItemRowView(listItem: listItem)
                    }
                }
                .onDelete(perform: deleteListItem)
                
                ForEach(listNameCoreData.itemsArray) { listItem in
                    if (listItem.isLooking && !listItem.isFound) {
                        ListItemRowView(listItem: listItem)
                    }
                }
                .onDelete(perform: deleteListItem)
            }
            
            
            //            List{
            //                Section{
            //                    if stillLookingItems.isEmpty {
            //                        Text("Nothing Left to shop For")
            //                    }else {
            //                        ForEach(stillLookingItems){ $listItem in
            //                                ListItemRowView(listItem: $listItem)
            //                        }.onDelete(perform: deleteListItem)
            //                    }
            //                } header: {
            //                    Text("Still Looking")
            //                }
            //                Section{
            //                    if foundItems.isEmpty {
            //                        Text("Nothing here")
            //                    }else {
            //                        ForEach(foundItems){ $listItem in
            //                                ListItemRowView(listItem: $listItem)
            //                        }.onDelete(perform: deleteListItem)
            //                    }
            //                } header: {
            //                    Text("Found")
            //                }
            //                Section{
            //                    if notFoundItems.isEmpty {
            //                        Text("found everything?")
            //                    }else {
            //                        ForEach(notFoundItems){ $listItem in
            //                                ListItemRowView(listItem: $listItem)
            //                        }.onDelete(perform: deleteListItem)
            //                    }
            //                } header: {
            //                    Text("Not Found")
            //                }
            //            }
            
            
            //            Style of the list
            //            .listStyle(.plain)
            Button {
                sheetShow.toggle()
            } label: {
                Image(systemName: "plus")
                    .font(.headline)
                    .foregroundColor(Color.black)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .foregroundColor(Color.orange)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 10)
            }
            .padding(50)
        }
        .sheet(isPresented: $sheetShow) {
            AddListItemSheetShow(listNameCoreData: listNameCoreData)
        }
        .navigationTitle(listNameCoreData.listName ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    DoneView(listNameCoreData: listNameCoreData)
                } label: {
                    Text("Done")
                }
                
            }
        }
    }
    
    // Delete an Item in List
    func deleteListItem(indexSet: IndexSet) {
        for index in indexSet{
            let item = listNameCoreData.itemsArray[index]
            print(item)
            listNameCoreDataVM.manager.context.delete(item)
            listNameCoreDataVM.save()
        }
    }
    
}

// MARK: - List Item Row View
struct ListItemRowView: View {
    
    @StateObject var listItem: ListItem
    @State var sheetShow: Bool = false
    
    var body: some View{
        HStack {
            Image(systemName: listItem.isLooking ? (listItem.isFound ? "checkmark.circle" : "multiply.circle") : "circle")
                .foregroundColor(listItem.isLooking ? (listItem.isFound ? Color.green: Color.red ) : Color.black)
                .onTapGesture {
                    sheetShow.toggle()
                }
            Text(listItem.unwrappeditemName)
                .onLongPressGesture {
                    print("Long pressed \(listItem.unwrappeditemName)")
                }
        }
        .sheet(isPresented: $sheetShow) {
            ToggleListItemSheetShow(listItem: listItem)
                .presentationDetents([.height(200)])
        }
    }
}

// MARK: - Add New Item Sheet View
struct AddListItemSheetShow: View {
    
    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM
    @StateObject var listNameCoreData: ListName
    @State var inputTextName: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View{
        VStack {
            TextField("Add List Name", text: $inputTextName)
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color.gray)
                .cornerRadius(10)
                .padding( 20)
            VStack {
                Button {
                    if !(inputTextName.count<2) {
                        listNameCoreDataVM.addListItem(inputListItem: inputTextName, listName: listNameCoreData)
                        dismiss()
                    }
                    dismiss()
                } label: {
                    Text("Done")
                        .padding(10)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .padding(10)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
            }
        }
        .presentationDetents([.height(200)])
    }
}


// MARK: - Toggle List Item View Condition
struct ToggleListItemSheetShow: View {
    
    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM
    //    @EnvironmentObject var listItemCoreDataVM: ListItemCoreDataVM
    @StateObject var listItem: ListItem
    
    @Environment(\.dismiss) private var dismiss
    var body: some View{
        VStack {
            Button {
                listNameCoreDataVM.updateIsLooking(listItemsCoreData: listItem)
                dismiss()
            } label: {
                Text("Still Looking")
            }
            
            Button {
                listNameCoreDataVM.updateIsFound(listItemsCoreData: listItem)
                dismiss()
            } label: {
                Text("Found")
            }
            
            Button {
                listNameCoreDataVM.updateIsNotFound(listItemsCoreData: listItem)
                dismiss()
            } label: {
                Text("Not Found")
            }
        }
    }
}

// MARK: - Done Button
/*
 This is button is very crucial as it will be adding data from listNames to pantry
 */

struct DoneView: View {
    
    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM
    @StateObject var listNameCoreData: ListName
    @Environment(\.dismiss) var dismiss
    
    var body: some View{
        ZStack {
            Color.black
            VStack{
                VStack{
                    ForEach(listNameCoreDataVM.foundItemsArray) { listItem in
                        // All the items that are found to be moved to pantry
                        if (listItem.isLooking && listItem.isFound) {
                            HStack {
                                Text(listItem.unwrappeditemName)
                                Text(String(format: "%.0f", listItem.itemCount))
                            }
                        }
                    }
                    .padding(10)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        for listItem in listNameCoreData.itemsArray {
                            listNameCoreDataVM.addPantry(itemName: listItem.unwrappeditemName, itemCount: listItem.itemCount)
                        }
                        
                    }) {
                        Text("Add to Pantry")
                    }
                    .padding(10)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                }
                .padding(10)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.7))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                
                VStack{
                    ForEach(listNameCoreDataVM.notFoundItemsArray) { listItem in
                        // All the items that are not found to be moved to a new List
                        if (listItem.isLooking && !listItem.isFound) {
                            HStack {
                                Text(listItem.unwrappeditemName)
                                Text(String(format: "%.0f", listItem.itemCount))
                            }
                        }
                    }
                    .padding(10)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        //                    for listItem in listNameCoreData.itemsArray {
                        //                        listNameCoreDataVM.addPantry(itemName: listItem.unwrappeditemName, itemCount: listItem.itemCount)
                        //                    }
                    }) {
                        Text("Add to Next List")
                    }
                    .padding(10)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                }
                .padding(10)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.7))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
                
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                }
                .padding(10)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                
            }
        }
    }
}


// MARK: - Preview
struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ShoppingListMainView()
        }
        .environmentObject(ListNameCoreDataVM())
    }
}
