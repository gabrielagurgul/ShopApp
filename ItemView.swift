//
//  ItemView.swift
//  ShopApp
//
//  Created by Gabriela Gurgul on 27/05/2021.
//


import UIKit

class ItemView: UIView {
  
  private var imageView: UIImageView!
  private var indicatorView: UIActivityIndicatorView!
  private var valueObservation: NSKeyValueObservation!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  init(frame: CGRect, coverUrl: String) {
    super.init(frame: frame)
    commonInit()
    NotificationCenter.default.post(name: .BLDownloadImage, object: self, userInfo: ["imageView": imageView, "imageUrl" : coverUrl])
  }
  
  private func commonInit() {
    // Setup the background
    backgroundColor = .black
    // Create the cover image view
    imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    valueObservation = imageView.observe(\.image, options: [.new]) { [unowned self] observed, change in
      if change.newValue is UIImage {
        self.indicatorView.stopAnimating()
      }
    }
    
    
    addSubview(imageView)
    // Create the indicator view
    indicatorView = UIActivityIndicatorView()
    indicatorView.translatesAutoresizingMaskIntoConstraints = false
    indicatorView.activityIndicatorViewStyle = .whiteLarge
    indicatorView.startAnimating()
    addSubview(indicatorView)
    
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
      imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
      imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
      imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
      indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
      ])
  }
  
  func highlightAlbum(_ didHighlightView: Bool) {
    if didHighlightView == true {
      backgroundColor = .white
    } else {
      backgroundColor = .black
    }
  }
  
}
