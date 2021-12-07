//
//  ItemStore.swift
//  LootLogger-MahaNasser
//
//  Created by Maha S on 14/11/2021.
//

import UIKit

class ItemStore {
  var allItems = [Item]()
  
  @discardableResult func createItem() -> Item {
    let newItem = Item(random: true)
    allItems.append(newItem)
    return newItem
    
  }
  
  
  let itemArchiveURL: URL = {
    let documentsDirectories =
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = documentsDirectories.first!
    return documentDirectory.appendingPathComponent("items.plist")
  }()
  
  
  init() {
    do {
      let data = try Data(contentsOf: itemArchiveURL)
      let unarchiver = PropertyListDecoder()
      let items = try unarchiver.decode([Item].self, from: data)
      allItems = items
    } catch {
      print("Error reading in saved items: \(error)")
    }
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self,
                                   selector: #selector(saveChanges),
                                   name: UIScene.didEnterBackgroundNotification,
                                   object: nil)
  }
  
  
  @objc func saveChanges() throws {
    print("Saving items to: \(itemArchiveURL)")
    let encoder = PropertyListEncoder()
    
    guard let data = try? encoder.encode(allItems) else {
      throw ItemStore.Error.encodingError
    }
    guard let _ = try? data.write(to: itemArchiveURL, options: [.atomic]) else {
      throw ItemStore.Error.writingError
    }
    print("Saved all of the items")
  }
  
  
  func removeItem(_ item: Item) {
    if let index = allItems.firstIndex(of: item) {
      allItems.remove(at: index)
    }
  }
  
  
  func moveItem(from fromIndex: Int, to toIndex: Int) {
    if fromIndex == toIndex {
      return }
    // Get reference to object being moved so you can reinsert it
    let movedItem = allItems[fromIndex]
    // Remove item from array
    allItems.remove(at: fromIndex)
    // Insert item in array at new location
    allItems.insert(movedItem, at: toIndex)
  }
  
}
