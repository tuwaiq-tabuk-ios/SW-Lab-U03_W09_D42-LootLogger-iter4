//
//  ItemStore.swift
//  LootLoggers
//
//  Created by Ahmed Alqhtani on 12/04/1443 AH.
//

import UIKit
class ItemStore {
  
  var allItems = [Item]()
  enum ErrorHandling: Error {
          case encodingError
          case writingError
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
              
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                           selector: #selector(saveChanges),
                           name: UIScene.didEnterBackgroundNotification,
                           object: nil)
     } catch (let error) {
        print("Error reading in saved items: \(error)")
     }
  }
  
  @discardableResult func createItem() -> Item {
    let newItem = Item(random: true)
    allItems.append(newItem)
    return newItem
  }
  
  //  init() {
  //    for _ in 0..<5 {
  //      createItem()
  //    }
  //  }
  
  func removeItem(_ item: Item) {
    if let index = allItems.firstIndex(of: item) {
      allItems.remove(at: index)
    }
  }
  func moveItem(from fromIndex: Int, to toIndex: Int) {
    if fromIndex == toIndex {
      return }
    
    let movedItem = allItems[fromIndex]
    
    allItems.remove(at: fromIndex)
    
    allItems.insert(movedItem, at: toIndex)
  }
  
  
  @objc func saveChanges () {
      do {
        try archiveChanges ()
      } catch ErrorHandling.encodingError {
              print("Couldn't encode items.")
      } catch ErrorHandling.writingError {
              print("Couldn't write to file.")
      } catch (let error){
              print("Error: \(error)")
      }
  }


  func archiveChanges () throws {
      print("Saving items to: \(itemArchiveURL)")
      let encoder = PropertyListEncoder()

      guard let data = try? encoder.encode(allItems)
      else {
              throw ItemStore.ErrorHandling.encodingError
      }
      guard let _ = try? data.write(to: itemArchiveURL, options: [.atomic])
      else {
              throw ItemStore.ErrorHandling.writingError
      }
      print ("Saved all of the items")
  }
 
  
  
}
