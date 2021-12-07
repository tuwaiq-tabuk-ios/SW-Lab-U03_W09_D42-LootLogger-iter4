//
//  ItemStore.swift
//  LootLogger
//
//  Created by Yousef Albalawi on 11/04/1443 AH.
//


import UIKit

class ItemStore  {
  enum ErrurHanding:Error {
    case encodingError,writingError
  }
  
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
      notificationCenter.addObserver(self,selector: #selector(saveChanges),name:UIScene.keyboardDidHideNotification,object: nil)
  }
  
  var allItems = [Item]()
  let itemArchiveURL: URL = {
    let documentsDirectories =
      FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = documentsDirectories.first!
    return documentDirectory.appendingPathComponent("items.plist")
  }()
  
  let myNotificationKey = "com.jonault.LootLogger"
     
     var uniqueSceneIdentifier: String!

     func sendNotification()
     {
         let notificationCenter = NotificationCenter.default
         notificationCenter.post(name: Notification.Name(rawValue: myNotificationKey),
                                 object: self,
                                 userInfo: ["identifier": uniqueSceneIdentifier!])
     }
     
     func catchNotification(notification:Notification) -> Void {
         guard let sceneIdentifier = notification.userInfo!["identifier"] else { return }
         
         let senderSceneIdentifier = "\(sceneIdentifier)"
         if (senderSceneIdentifier != uniqueSceneIdentifier!)
         {
             itemStore.loadChanges()
             tableView.reloadData()
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
    // Get reference to object being moved so you can reinsert it
    let movedItem = allItems[fromIndex]
    // Remove item from array
    allItems.remove(at: fromIndex)
    // Insert item in array at new location
    allItems.insert(movedItem, at: toIndex)
  }
  
  
  @objc func saveChanges() throws {
    print("Saving items to: \(itemArchiveURL)")
    do {
      let encoder = PropertyListEncoder()
      let data = try encoder.encode(allItems)
      try data.write(to: itemArchiveURL, options: [.atomic])
      print("Saved all of the items")
    } catch let encodingError {
      throw encodingError
    }
  }
  
  
  func archiveChanged () throws {
    print("Siving IItems To: \(itemArchiveURL)")
    let cnoder = PropertyListEncoder ()
    guard let data = try? cnoder.encode(allItems) else {
      throw ItemStore.ErrurHanding.encodingError
    }
    guard let _ = try? data.write(to: itemArchiveURL, options: [.atomic])
    else {
      throw ItemStore.ErrurHanding.writingError
  }
    print("is Sev Errur")
}

  let myNotificationKey = "com.jonault.LootLogger"
     
     var uniqueSceneIdentifier: String!

     func sendNotification()
     {
         let notificationCenter = NotificationCenter.default
         notificationCenter.post(name: Notification.Name(rawValue: myNotificationKey),
                                 object: self,
                                 userInfo: ["identifier": uniqueSceneIdentifier!])
     }
     
    
  
}
