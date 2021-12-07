//
//  DetailViewController.swift
//  Table-ShuruqAlanazi
//
//  Created by Shorouq AlAnzi on 22/04/1443 AH.
//

import Foundation
import UIKit


class DetailViewController: UIViewController , UITextFieldDelegate {
  
  @IBOutlet var nameField: UITextField!
  @IBOutlet var serialNumberField: UITextField!
  @IBOutlet var valueField: UITextField!
  @IBOutlet var dateLabel: UILabel!

  
  @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
      view.endEditing(true)
  }
  
  
  override func viewDidLoad() {
    valueField.keyboardType = .numberPad
  }
 
  
  var item: item!
  { didSet {
          navigationItem.title = item.name
      }
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
  
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
  return true }
  

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

  
}

