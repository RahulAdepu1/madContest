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
            let pantry = listNameCoreDataVM.pantryCoreData
            if pantry.isEmpty {
                ZStack {
                    Color.gray.ignoresSafeArea()
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
                .background(Color.black.opacity(0.4))
            }
        }
        .navigationTitle("Pantry")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    
}


//MARK: - Pantry Row View
enum editFinishedSheet:Identifiable {
    case edit
    case complete
    
    var id: String { UUID().uuidString }
}

struct pantryRowView: View {
    
    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM
    @StateObject var pantry: Pantry
    
    @State private var activeSheet: editFinishedSheet?
    
    var body: some View{
        
        HStack(alignment: .top){
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 40, height: 40)
                .padding(10)
                .background(
                    Color.black.opacity(0.5)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                )
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
                }
            
            VStack(alignment: .leading) {
                Text(pantry.itemName ?? "UnKnown")
                    .font(.body)
                    .padding(.top, 1)
                Text(pantry.itemBrand ?? "")
                    .font(.subheadline)
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
        .background(Color.black.opacity(0.5))
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .onTapGesture(count: 2, perform: {
            activeSheet = .complete
        })
        .onTapGesture(count: 1, perform: {
            activeSheet = .edit
        })
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .edit:
                pantryItemDetailView(pantry: pantry)
                    .presentationDetents([.medium])
            case .complete:
                pantryItemFinishedView()
                    .presentationDetents([.height(100)])
            }
        }
    }
}

//MARK: - Pantry Item Detail View
struct pantryItemDetailView: View {
    
    @StateObject var pantry: Pantry
    @Environment(\.dismiss) var dismiss
    
    var body: some View{
        VStack{
            pantryItemDetailIntro(pantry: pantry)
            Divider()
                .padding(.horizontal, 20)
            pantryItemDetailCondition(pantry: pantry)
            Divider()
                .padding(.horizontal, 20)
            pantryItemDetailExpStock(pantry: pantry)
            Divider()
                .padding(.horizontal, 20)
            pantryItemDetailLocCat(pantry: pantry)
            Divider()
            .padding(.horizontal, 20)
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Edit")
                        .modifier(CustomButtonDesign())
                }
                Button {
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
            Image(systemName: "multiply")
                .fontWeight(.heavy)
                .onTapGesture {
                    dismiss()
                }
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .padding(20)
        
    }
}

//MARK: - Pantry Item Detail View - Condition
struct pantryItemDetailCondition: View {
    @StateObject var pantry: Pantry
    var body: some View{
        HStack{
            VStack{
                Text("Good")
                    .font(.headline)
                Text("Status")
                    .font(.caption)
            }
            .padding(.horizontal, 30)
            Spacer()
            VStack{
                Text(String(format: "%.0f", pantry.count))
                    .font(.headline)
                Text("Quantity")
                    .font(.caption)
            }
            .padding(.horizontal, 10)
            Spacer()
            VStack{
                Text(String(format: "%.0f", pantry.consumedAmount))
                    .font(.headline)
                Text("consumed")
                    .font(.caption)
            }
            .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity)
//        .background(Color.gray)
        .padding(.horizontal, 20)
    }
}

//MARK: - Pantry Item Detail View - Stocked
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
            Spacer()
            VStack{
                Text(dateFormatter.string(from: pantry.unwrappedExpiryDate))
                    .font(.body)
                Text("Expires on")
                    .font(.caption)
            }
            .padding(.horizontal, 10)
            
            Spacer()
            
            VStack{
                Text(dateFormatter.string(from: pantry.unwrappedStockedDate))
                    .font(.body)
                Text("Stocked on")
                    .font(.caption)
            }
//            .padding(.horizontal, 10)
            Spacer()
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
            Spacer()
            VStack{
                Text(pantry.location ?? "")
                    .font(.body)
                Text("Location")
                    .font(.caption)
            }
//            .padding(.horizontal, 35)
            Spacer()
            Spacer()
            VStack{
                Text(pantry.category ?? "")
                    .font(.body)
                Text("Category")
                    .font(.caption)
            }
//            .padding(.horizontal, 35)
            Spacer()
        }
        .frame(maxWidth: .infinity)
//        .background(Color.gray)
        .padding(.horizontal, 20)
//
    }
}

//MARK: - Pantry Item Edit View
struct PantryItemEditView: View {
    var body: some View{
    Text("")
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
    
    func expiryDateCheck(stockedDate: Date, expiryDate: Date) -> [Int]{
        let components = Calendar.current.dateComponents([.day], from: stockedDate, to: expiryDate)
        let totalDays = components.day!
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
    
    var pantry: Pantry
    
    var body: some View{
        VStack {
            let dates = ExpiryDateCheck().expiryDateCheck(stockedDate: pantry.unwrappedStockedDate, expiryDate: pantry.unwrappedExpiryDate)
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
            }else if weeks == 0 {
                Text("Expires in")
                    .font(.caption)
                Text(days == 1 ? "\(days) Day" : "\(days) Days")
                    .font(.title2)
            }else if (weeks > 0 && days == 0) {
                Text("Expires in")
                    .font(.caption)
                Text(weeks == 1 ? "\(weeks) Wk" : "\(weeks) Wks" )
                    .font(.title2)
            }else if (weeks > 0 && days > 0) {
                Text("Expires in")
                    .font(.caption)
                Text(weeks == 1 ? "\(weeks) Wk" : "\(weeks) Wks" )
                    .font(.title2)
                Text(days == 1 ? "\(days) Day" : "\(days) Days")
                    .font(.body)
            }
        }
    }
}


//MARK: - Preview
struct PantryMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            PantryMainView()
        }
        .environmentObject(ListNameCoreDataVM())
    }
}
