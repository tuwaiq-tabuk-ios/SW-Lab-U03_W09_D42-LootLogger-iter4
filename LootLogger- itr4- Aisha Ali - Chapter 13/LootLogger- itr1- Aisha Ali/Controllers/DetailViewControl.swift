//
//  SecondView .swift
//  LootLogger- itr1- Aisha Ali
//
//  Created by Aisha Ali on 11/25/21.
//

import Foundation
import UIKit
class DetailViewController:UIViewController{
  
  var item: Item! { didSet {
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
  
  
  
  
  
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var serialNumberField: UITextField!
  @IBOutlet weak var valueField: UITextField!
  @IBOutlet weak var dateLabel: UILabel!
  
  
  @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
    
    view.endEditing(true)
    
  }
  
  
  //MARK: - This for segue betwen Detail Scene and Date Secreen
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    switch segue.identifier {
    case "editDate":
      let editDateController = segue.destination as! ModifyDateController
      editDateController.item = item
    default:
      preconditionFailure("Unexpected Segue identifier")
    }
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    nameField.text = item.name
    serialNumberField.text = item.serialNumber
    
    valueField.text = numberFormatter.string(
      from: NSNumber(value: item.valueInDollars))
    
    dateLabel.text = dateFormatter.string(from: item.dateCreated)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true }
  
  
  
  override func viewWillDisappear(_ animated: Bool) {
    
    super.viewWillDisappear(animated)
    
    //    view.endEditing(true)
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
