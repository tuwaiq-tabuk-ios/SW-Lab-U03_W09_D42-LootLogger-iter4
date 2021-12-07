//
//  ItemStore.swift
//  LootLogger
//
//  Created by Ressam Al-Thebailah on 10/04/1443 AH.
//

import UIKit

class ItemStore {
var allItems = [Item]()
  
  let itemArchiveURL : URL = {
    let documentsDirectoris =
      FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)
    let documentDirectory = documentsDirectoris.first!
    return documentDirectory.appendingPathComponent("items.plist")
  }()
  
  
  @discardableResult func createItem() -> Item {
      let newItem = Item(random: true)
      allItems.append(newItem)
      return newItem
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
  
  
  enum Error: Swift.Error {
          case encodingError
          case writingError
          case mysteriousError
  }
  
  init() {
     do {
        let data = try Data(contentsOf: itemArchiveURL)
        let unarchiver = PropertyListDecoder()
        let items = try unarchiver.decode([Item].self, from: data)
        allItems = items
              
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                           selector: #selector(saveChanges),
                           name: UIScene.didEnterBackgroundNotification,
                           object: nil)
     } catch (let error) {
        print("Error reading in saved items: \(error)")
     }
  }

  // Adapter
  @objc func saveChanges () {
      do {
        try archiveChanges ()
      } catch Error.encodingError {
              print("Couldn't encode items.")
      } catch Error.writingError {
              print("Couldn't write to file.")
      } catch (let error){
              print("Error: \(error)")
      }
  }

  // Archive changes
  func archiveChanges () throws {
      print("Saving items to: \(itemArchiveURL)")
      let encoder = PropertyListEncoder()

      guard let data = try? encoder.encode(allItems) else {
              throw ItemStore.Error.encodingError
      }
      guard let _ = try? data.write(to: itemArchiveURL, options: [.atomic]) else {
              throw ItemStore.Error.writingError
      }
      print ("Saved all of the items")
  }
}
