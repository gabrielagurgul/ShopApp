//
//  PersistencyManager.swift
//  ShopApp
//
//  Created by Gabriela Gurgul on 27/05/2021.
//

import Foundation
import UIKit

final class PersistencyManager {
  private var items = [Item]()
  
  init() {
    let savedURL = documents.appendingPathComponent(Filenames.Items)
    var data = try? Data(contentsOf: savedURL)
    if data == nil, let bundleURL = Bundle.main.url(forResource: Filenames.Items, withExtension: nil) {
      data = try? Data(contentsOf: bundleURL)
    }

    if let itemData = data,
      let decodedAlbums = try? JSONDecoder().decode([Item].self, from: itemData) {
      items = decodedAlbums
      saveItems()
    }
  }
  
  func getItems() -> [Item] {
    return items
  }
  
  func addItem(_ album: Item, at index: Int) {
    if (items.count >= index) {
      items.insert(album, at: index)
    } else {
      items.append(album)
    }
  }
  
  func deleteItem(at index: Int) {
    items.remove(at: index)
  }
  
  private var cache: URL {
    return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
  }
  
  
  func saveImage(_ image: UIImage, filename: String) {
    let url = cache.appendingPathComponent(filename)
    guard let data = UIImagePNGRepresentation(image) else {
      return
    }
    try? data.write(to: url, options: [])
  }

  func getImage(with filename: String) -> UIImage? {
    let url = cache.appendingPathComponent(filename)
    guard let data = try? Data(contentsOf: url) else {
      return nil
    }
    return UIImage(data: data)
  }
  
  private var documents: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
  private enum Filenames {
    static let Items = "albums.json"
  }
  func saveItems() {
    let url = documents.appendingPathComponent(Filenames.Items)
    let encoder = JSONEncoder()
    guard let encodedData = try? encoder.encode(items) else {
      return
    }
    try? encodedData.write(to: url)
  }
  
}
