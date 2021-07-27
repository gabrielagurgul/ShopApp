//
//  ViewController.swift
//  ShopApp
//
//  Created by Gabriela Gurgul on 27/05/2021.
//

import UIKit

final class ViewController: UIViewController {
  
  private enum Constants {
    static let CellIdentifier = "Cell"
    static let IndexRestorationKey = "currentItemIndex"
  }
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var undoBarButtonItem: UIBarButtonItem!
  @IBOutlet var trashBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var horizontalScrollerView: HorizontalScrollerView!
  
  private var currentItemIndex = 0
  private var currentItemData: [ItemData]?
  private var allItems = [Item]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //1
    allItems = LibraryAPI.shared.getItems()
    
    //2
    tableView.dataSource = self
    horizontalScrollerView.dataSource = self
    horizontalScrollerView.delegate = self
    horizontalScrollerView.reload()
    showDataForAlbum(at: currentItemIndex)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    horizontalScrollerView.scrollToView(at: currentItemIndex, animated: false)
  }
  
  private func showDataForAlbum(at index: Int) {
    
    // defensive code: make sure the requested index is lower than the amount of albums
    if (index < allItems.count && index > -1) {
      // fetch the album
      let album = allItems[index]
      // save the albums data to present it later in the tableview
      currentItemData = album.tableRepresentation
    } else {
      currentItemData = nil
    }
    // we have the data we need, let's refresh our tableview
    tableView.reloadData()
  }
  
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let albumData = currentItemData else {
      return 0
    }
    return albumData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier, for: indexPath)
    if let albumData = currentItemData {
      let row = indexPath.row
      cell.textLabel!.text = albumData[row].title
      cell.detailTextLabel!.text = albumData[row].value
    }
    return cell
  }
  
}

extension ViewController: HorizontalScrollerViewDelegate {
  func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, didSelectViewAt index: Int) {
    
    let previousItemView = horizontalScrollerView.view(at: currentItemIndex) as! ItemView
    previousItemView.highlightAlbum(false)
    
    currentItemIndex = index
    
    let itemView = horizontalScrollerView.view(at: currentItemIndex) as! ItemView
    previousItemView.highlightAlbum(true)
    
    showDataForAlbum(at: index)
  }
}

extension ViewController: HorizontalScrollerViewDataSource {
  func numberOfViews(in horizontalScrollerView: HorizontalScrollerView) -> Int {
    return allItems.count
  }
  
  func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, viewAt index: Int) -> UIView {
    let album = allItems[index]
    let albumView = ItemView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), coverUrl: album.coverUrl)
    if currentItemIndex == index {
      albumView.highlightAlbum(true)
    } else {
      albumView.highlightAlbum(false)
    }
    return albumView
  }
}

//MARK: State restoration
extension ViewController {

  override func encodeRestorableState(with coder: NSCoder) {
    coder.encode(currentItemIndex, forKey: Constants.IndexRestorationKey)
    super.encodeRestorableState(with: coder)
  }
  
  override func decodeRestorableState(with coder: NSCoder) {
    super.decodeRestorableState(with: coder)
    currentItemIndex = coder.decodeInteger(forKey: Constants.IndexRestorationKey)
    showDataForAlbum(at: currentItemIndex)
    horizontalScrollerView.reload()
  }
  
}

