//
//  DetailViewController.swift
//  Table Rawabi
//
//  Created by روابي باجعفر on 20/04/1443 AH.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet var nameField: UITextField!
          @IBOutlet var serialNumberField: UITextField!
          @IBOutlet var valueField: UITextField!
          @IBOutlet var dateLabel: UILabel!
  
  
  @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  
  let numberFormatter: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.numberStyle = .decimal
      formatter.minimumFractionDigits = 2
      formatter.maximumFractionDigits = 2
      return formatter
  }()
  let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      formatter.timeStyle = .none
      return formatter
  }()
  
  
  var item: Item!
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          nameField.text = item.name
          serialNumberField.text = item.serialNumber
        valueField.text =
                numberFormatter.string(from: NSNumber(value: item.valueInDollars))
            dateLabel.text = dateFormatter.string(from: item.dateCreated)
  
        var item: Item! { didSet {
                navigationItem.title = item.name
            }
        }
      }
  

override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  
  // Clear first responder
     view.endEditing(true)
  
    // "Save" changes to item
    item.name = nameField.text ?? ""
    item.serialNumber = serialNumberField.text
    if let valueText = valueField.text,
        let value = numberFormatter.number(from: valueText) {
        item.valueInDollars = value.intValue
} else {
        item.valueInDollars = 0
    }
}
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
  return true }
}
