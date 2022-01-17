//
//  ProductCard.swift
//  EdvoraInternshipApp
//
//  Created by Rahul Narayanan on 1/14/22.
//

import SwiftUI

struct ProductCard: View {
    var product: Product
    
    var productAddress: String {
        (product.address["city"] ?? "") + ", " + (product.address["state"] ?? "")
    }
    
    var formattedDate: String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = formatter.date(from: product.date)
        
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter.string(from: date ?? Date())
        
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: URL(string: product.image)) { image in
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)

                VStack(alignment: .leading) {
                    Text(product.product_name)
                        .bold()
                    Text(product.brand_name)
                    Text("$" + String(product.price))
                }
            }
            
            HStack {
                Text(productAddress)
                Text(formattedDate)
            }
            
            Text(product.discription)
        }
        .padding()
        .background(.quaternary)
        .cornerRadius(10)
    }
}

struct ProductCard_Previews: PreviewProvider {
    static var previews: some View {
        let productPreview = Product(
            product_name: "Berkshire Hathway",
            brand_name: "Berkshire",
            discription: "Its a good product",
            date: "2019-12-08T16:50:02.153Z",
            time: "2017-05-26T04:26:38.621Z",
            image: "https://w7.pngwing.com/pngs/915/345/png-transparent-multicolored-balloons-illustration-balloon-balloon-free-balloons-easter-egg-desktop-wallpaper-party-thumbnail.png",
            price: 900,
            address: [
            "state": "Puducherry",
            "city": "Karaikal"
            ])
        
        
        return ProductCard(product: productPreview)
            .previewLayout(.fixed(width: 300, height: 200))
    }
}
