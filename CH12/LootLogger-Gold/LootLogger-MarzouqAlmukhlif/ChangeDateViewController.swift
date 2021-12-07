//
//  ChangeDate.swift
//  LootLogger-MarzouqAlmukhlif
//
//  Created by Marzouq Almukhlif on 20/04/1443 AH.
//

import UIKit

class ChangeDateViewController: UIViewController {
  
  @IBOutlet weak var datePicker: UIDatePicker!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureDatePicker()
  }
  var item: Item! {
    didSet {
          navigationItem.title = dateFormatter.string(from: item.dateCreated)
      }
  }
  
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
  }()
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    datePicker.date = item.dateCreated
  }
  
  
  func configureDatePicker() {
      let action = UIAction { _ in
          self.item.dateCreated = self.datePicker.date
      }
      datePicker.addAction(action, for: .valueChanged)
  }
  
}
