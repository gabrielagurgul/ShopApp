//
//  Item.swift
//  ShopApp
//
//  Created by Gabriela Gurgul on 27/07/2021.
//

import Foundation

struct Item: Codable {
  let title : String
  let price : String
  let desc : String
  let coverUrl : String
  let city : String
}

extension Item: CustomStringConvertible {
  var description: String {
    return "title: \(title)" +
      " price: \(price)" +
      " desc: \(desc)" +
      " coverUrl: \(coverUrl)" +
    " city: \(city)"
  }
}

typealias ItemData = (title: String, value: String)

extension Item {
  var tableRepresentation: [ItemData] {
    return [
      ("Name", title),
      ("Description", desc),
      ("Price", price),
      ("City", city)
    ]
  }
}
