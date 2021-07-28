//
//  LibraryAPI.swift
//  ShopApp
//
//  Created by Gabriela Gurgul on 27/07/2021.
//

import Foundation
import UIKit

final class ShopAPI {
  // 1
  static let shared = ShopAPI()
  private let persistencyManager = PersistencyManager()
  private let httpClient = HTTPClient()
  private let isOnline = false
  // 2
  private init() {
    NotificationCenter.default.addObserver(self, selector: #selector(downloadImage(with:)), name: .BLDownloadImage, object: nil)
  }
  
  func getItems() -> [Item] {
    return persistencyManager.getItems()
  }
  
  func addItem(_ item: Item, at index: Int) {
    persistencyManager.addItem(item, at: index)
    if isOnline {
      httpClient.postRequest("/api/addItem", body: item.description)
    }
  }
  
  func deleteItem(at index: Int) {
    persistencyManager.deleteItem(at: index)
    if isOnline {
      httpClient.postRequest("/api/deleteItem", body: "\(index)")
    }
  }
  
  @objc func downloadImage(with notification: Notification) {
    guard let userInfo = notification.userInfo,
      let imageView = userInfo["imageView"] as? UIImageView,
      let coverUrl = userInfo["coverUrl"] as? String,
      let filename = URL(string: coverUrl)?.lastPathComponent else {
        return
    }
    
    if let savedImage = persistencyManager.getImage(with: filename) {
      imageView.image = savedImage
      return
    }
    
    DispatchQueue.global().async {
      let downloadedImage = self.httpClient.downloadImage(coverUrl) ?? UIImage()
      DispatchQueue.main.async {
        imageView.image = downloadedImage
        self.persistencyManager.saveImage(downloadedImage, filename: filename)
      }
    }
  }
}
