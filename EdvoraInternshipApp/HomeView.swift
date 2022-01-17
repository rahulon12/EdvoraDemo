//
//  HomeView.swift
//  EdvoraInternshipApp
//
//  Created by Rahul Narayanan on 1/14/22.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var dataManager = DataManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                if dataManager.dataIsFetched {
                    VStack(alignment: .leading) {
                        ForEach(dataManager.filteredProducts.keys.sorted(), id: \.self) { category in
                            if !dataManager.filteredProducts[category]!.isEmpty {
                                Text(category)
                                    .font(.title)
                                    .bold()
                                    .padding(.horizontal)
                                Divider()
                                
                                ScrollView(.horizontal) {
                                    HStack {
                                        Spacer().frame(width: 16)
                                        ForEach(dataManager.filteredProducts[category]!, id: \.self) { product in
                                            ProductCard(product: product)
                                                .aspectRatio(3/2, contentMode: .fit)
                                        }
                                        Spacer().frame(width: 16)
                                    }
                                    //.offset(x: 16)
                                    .frame(maxHeight: 250)
                                }
                            }
                        }
                    }
                    .padding(.top)
                    .animation(.easeInOut, value: dataManager.filter)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Edvora")
            .task {
                await dataManager.fetchData()
            }
            .refreshable {
                await dataManager.fetchData()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        Task.init {
                            await dataManager.fetchData()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if dataManager.dataIsFetched {
                        Menu {
                            ForEach(dataManager.filter.filterOptions(for: dataManager.filteredProducts).keys.sorted(), id: \.self) { category in
                                Menu(category) {
                                    ForEach(Array(dataManager.filter.filterOptions(for: dataManager.filteredProducts)[category]!), id: \.self) { filterItem in
                                        Button {
                                            dataManager.filter.toggleFilterOption(filterItem, in: category)
                                        } label: {
                                            HStack {
                                                Text(filterItem)
                                                Spacer()
                                                if dataManager.filter.isFilterSelected(filterItem) {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: !dataManager.filter.isActive ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                        }

                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}
