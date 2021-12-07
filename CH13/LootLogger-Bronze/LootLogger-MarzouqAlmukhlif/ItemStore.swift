//
//  ItemStore.swift
//  LootLogger
//
//  Created by Marzouq Almukhlif on 09/04/1443 AH.
//

import UIKit

class ItemStore {
  enum ErrorHandling:Error {
    case encodingError,writingError
  }
  
  var allItems = [Item]()
  
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
              
     } catch (let error) {
        print("Error reading in saved items: \(error)")
     }
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self,
                       selector: #selector(catchSaveChanges),
                       name: UIScene.didEnterBackgroundNotification,
                       object: nil)
  }
  
  
  
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
  
  
  // Adapter
  @objc func catchSaveChanges () {
      do {
        try saveChanges ()
      } catch ErrorHandling.encodingError {
              print("Couldn't encode items.")
      } catch ErrorHandling.writingError {
              print("Couldn't write to file.")
      } catch (let error){
              print("Error: \(error)")
      }
  }

  func saveChanges () throws {
      print("Saving items to: \(itemArchiveURL)")
      let encoder = PropertyListEncoder()

      guard let data = try? encoder.encode(allItems) else {
              throw ItemStore.ErrorHandling.encodingError
      }
      guard let _ = try? data.write(to: itemArchiveURL, options: [.atomic]) else {
              throw ItemStore.ErrorHandling.writingError
      }
      print ("Saved all of the items")
  }
}
