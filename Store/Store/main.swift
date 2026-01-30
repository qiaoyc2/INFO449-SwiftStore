//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name: String { get }
    func price() -> Int
}
    

class Item: SKU {
    var name:String
    var priceEach: Int
    
    init(name: String, priceEach: Int){
        self.name = name
        self.priceEach = priceEach
    }
    
    func price() -> Int {
        return self.priceEach
    }
}

class Receipt {
    var receiptItems: [Item]
    
    init(_ receipt: [Item]){
        self.receiptItems = receipt
    }
    
    func add(_ item: Item) {
        self.receiptItems.append(item)
    }
    
    func items() -> [Item]{
        var itemList: [Item] = []
        for item in self.receiptItems{
            itemList.append(item)
        }
        return itemList
    }
    
    func total() -> Int {
        var sum = 0
        for item in receiptItems {
            sum += item.price()
        }
        return sum
    }
    
    func output() -> String{
        var output: String = "Receipt:\n"
        for item in self.receiptItems{
            var price: Int = item.price()
            var priceText = Array(String(price))
            if priceText.count == 2 {
                priceText.insert(contentsOf: Array("0."), at: (priceText.count - 2))
            } else if priceText.count == 1 {
                priceText.insert(contentsOf: Array("0.0"), at: (priceText.count - 2))
            } else {
                priceText.insert(".", at: (priceText.count - 2))
            }
            output.append("\(item.name): $\(String(priceText))\n")
        }
        var total: Int = self.total()
        var totalText = Array(String(total))
        if totalText.count == 2 {
            totalText.insert(contentsOf: Array("0."), at: (totalText.count - 2))
        } else if totalText.count == 1 {
            totalText.insert(contentsOf: Array("0.0"), at: (totalText.count - 2))
        } else {
            totalText.insert(".", at: (totalText.count - 2))
        }
        output += "------------------\nTOTAL: $\(String(totalText))"
        return output
    }
}

protocol PricingScheme {
    func discount(of item: Item) -> Int
}

class Register {
    var receipt: Receipt
    var pricingScheme: PricingScheme?
    
    init(){
        self.receipt = Receipt([])
    }
    
    func scan(_ item: Item){
        self.receipt.add(item)
    }
    
    func subtotal() -> Int{
        var sum: Int = 0
        var discounted: [Item] = []
        var discount: Int = 0
        for item in self.receipt.items(){
            sum += item.price()
            var count = self.receipt.items().filter { $0.name == item.name }.count
            if count % 3 == 0 && !discounted.contains(where: { $0.name == item.name }) {
                    discounted.append(item)
            }
        }
        for item in discounted{
            var count = self.receipt.items().filter { $0.name == item.name }.count
            discount += item.price() * (count / 3)
        }
        return sum - discount
    }
    
    func total() -> Receipt {
        var output = self.receipt
        self.receipt = Receipt([])
        return output
    }
    

}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

