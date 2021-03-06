//
//  HTTPClient.swift
//  ShopApp
//
//  Created by Gabriela Gurgul on 27/07/2021.
//

import UIKit

class HTTPClient {
  
  @discardableResult func getRequest(_ url: String) -> AnyObject {
    return Data() as AnyObject
  }
  
  @discardableResult func postRequest(_ url: String, body: String) -> AnyObject {
    return Data() as AnyObject
  }
  
  func downloadImage(_ url: String) -> UIImage? {
    let aUrl = URL(string: url)
    guard let data = try? Data(contentsOf: aUrl!),
      let image = UIImage(data: data) else {
        return nil
    }
    return image
  }
  
}
