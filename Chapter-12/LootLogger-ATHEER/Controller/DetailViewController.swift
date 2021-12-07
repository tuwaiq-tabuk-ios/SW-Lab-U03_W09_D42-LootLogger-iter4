//
//  DetailViewController.swift
//  LootLogger-ATHEER
//
//  Created by Atheer abdullah on 20/04/1443 AH.
//

import UIKit


class DetailViewController: UIViewController , UITextFieldDelegate {
  
  @IBOutlet weak var nameField: UITextField!
  
  @IBOutlet weak var serialField: UITextField!
  
  @IBOutlet weak var valueField: UITextField!
  
  
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
    
    view.endEditing(true)
  }
  
  
  var item: Item! {
    didSet {
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
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    nameField.text = item.name
    serialField.text = item.serialNumber
    valueField.text =
      numberFormatter.string(from: NSNumber(value: item.valueInDollars))
    dateLabel.text = dateFormatter.string(from: item.dateCreated)
    view.endEditing(true)
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      // "Save" changes to item
      item.name = nameField.text ?? ""
      item.serialNumber = serialField.text
      if let valueText = valueField.text,
          let value = numberFormatter.number(from: valueText) {
          item.valueInDollars = value.intValue
  } else {
          item.valueInDollars = 0
      }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    return true }
  }
  

  }




  

