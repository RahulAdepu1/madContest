//
//  HistoryMainView.swift
//  groceryCalculator
//
//  Created by Rahul Adepu on 4/3/23.
//

import SwiftUI

struct HistoryMainView: View {
    
    
    @State private var storeFilter = "Cost"
    @State var searchTextField: String = ""
    var body: some View {
        NavigationStack {
            VStack(spacing: 5){
                TextField("Search", text: $searchTextField)
                    .padding(10)
                    .foregroundColor(.black)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2)))
                    .padding(10)
                
                sortByRowView()
                
                Divider()
                ScrollView{
                    VStack{
                        ForEach(0..<10) { list in
                            NavigationLink {
                                historyDetailView(number: list)
                            } label: {
                                historyCardView()
                            }
                        }
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct HistoryMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            HistoryMainView()
        }
    }
}

struct historyCardView:View {
    var body: some View{
        
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading){
                    Text("Apr 02, 2023")
                        .font(.title3)
                    Text("3 items")
                        .font(.body)
                    Text("$7.95")
                        .font(.subheadline)
                }
                .padding(.horizontal, 20)
                Spacer()
                VStack(alignment: .trailing){
                    Text("Walmart")
                        .font(.body)
                    Text("In-Store")
                        .font(.subheadline)
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 8)
//            .background(Color.black.opacity(0.2))
            
            ScrollView(.horizontal){
                HStack{
                    ForEach(0..<10) { list in
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .padding(.horizontal, 10)
//                            .background(Color.black.opacity(0.2))
                    }
                }
            }
            .padding(.horizontal, 5)
//            .background(Color.black.opacity(0.2))
        }
        .frame(height: 150)
        .frame(maxWidth: .infinity)
        .foregroundColor(Color.black)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

struct historyDetailView: View {
    @State var number: Int
    
    var body: some View{
        Text("Page \(number)")
    }
}

struct sortByRowView:View {
    @EnvironmentObject var listNameCoreDataVM: ListNameCoreDataVM
    @State private var defaultFilter = "default"
    
    var body: some View{
        VStack{
            HStack{
                Text("Sort By:")
                Button {
                    listNameCoreDataVM.historySortOption = .default
                    listNameCoreDataVM.fetchHistory()
                } label: {
                    Text("default")
                        .modifier(sortByButtonView())
                }
                Button {
                    listNameCoreDataVM.historySortOption = .store
                    listNameCoreDataVM.fetchHistory()
                } label: {
                    Text("Store")
                        .modifier(sortByButtonView())
                }
                Button {
                    listNameCoreDataVM.historySortOption = .cost
                    listNameCoreDataVM.fetchHistory()
                } label: {
                    Text("Cost")
                        .modifier(sortByButtonView())
                }
            }
        }
    }
}

struct sortByButtonView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(8)
            .foregroundColor(Color.black)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
    }
}
