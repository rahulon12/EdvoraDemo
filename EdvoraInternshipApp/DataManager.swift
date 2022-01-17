//
//  DataManager.swift
//  EdvoraInternshipApp
//
//  Created by Rahul Narayanan on 1/14/22.
//

import SwiftUI

struct Product: Hashable, Decodable {
    let product_name, brand_name, discription, date, time, image: String
    let price: Int
    let address: [String: String]
}

struct SelectedFilter: Equatable {
    private(set) var productName: String? = nil
    private(set) var state: String? = nil
    private(set) var city: String? = nil
    
    
    
    var isActive: Bool {
        (productName != nil) || (state != nil) || (city != nil)
    }
    
    func filterOptions(for filteredProducts: [String: [Product]]) -> [String: Set<String>] {
        var filterOptions: [String: Set<String>] = ["Product Name": [], "City": [], "State": []]
        
        filterOptions["Product Name"] = Set(filteredProducts.keys.sorted())
        filterOptions["City"] = Set(filteredProducts.values.flatMap({ $0 }).map({ $0.address["city"]! }))
        filterOptions["State"] = Set(filteredProducts.values.flatMap({ $0 }).map({ $0.address["state"]! }))
        
        return filterOptions
    }
    
    mutating func toggleFilterOption(_ option: String, in category: String) {
        switch category {
        case "Product Name":
            productName = (productName == nil) ? option : nil
        case "City":
            city = (city == nil) ? option : nil
        case "State":
            state = (state == nil) ? option : nil
        default:
            productName = nil; state = nil; city = nil
        }
    }
    
    func isFilterSelected(_ filter: String) -> Bool {
        (productName == filter) || (state == filter) || (city == filter)
    }
}

class DataManager: ObservableObject {
    
    @Published var dataIsFetched = false
    @Published var products = [String: [Product]]()
    
    @Published var filteredProducts = [String: [Product]]()
    
    @Published var filter: SelectedFilter = SelectedFilter() {
        didSet {
            filteredProducts.keys.forEach { category in
                filteredProducts[category] = products[category]?.filter({ product in
                    if !filter.isActive {
                        return true
                    } else {
                        var isInFilter = false
                        if filter.productName != nil {
                            isInFilter = (filter.productName == product.product_name)
                        }
                        if filter.city != nil {
                            isInFilter = (filter.city == product.address["city"])
                        }
                        if filter.state != nil {
                            isInFilter = (filter.state == product.address["state"])
                        }
                        
                        return isInFilter
                    }
                })
            }
        }
    }
    
    init() {
        
    }
    
    @MainActor
    func fetchData() async {
        
        guard let url = URL(string: "https://assessment-edvora.herokuapp.com/") else { return }
        
        do {
            dataIsFetched = false
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let productData = try JSONDecoder().decode([Product].self, from: data)
            products = Dictionary(grouping: productData, by: { $0.product_name })
            filteredProducts = products
        } catch {
            print("Error occured \(error)")
        }
        
        dataIsFetched = true
    }
    
}
