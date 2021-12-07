//
//  DateCreatedViewController.swift
//  LootLogger
//
//  Created by arwa balawi on 01/05/1443 AH
import UIKit

class DatePickerViewController: UIViewController {
  var datePicker: UIDatePicker!
  
  var item: Item!

  override func loadView() {
    let view = UIView()
    view.backgroundColor = UIColor.white
    self.view = view
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Date Created"

    datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.date = item.dateCreated
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(datePicker)

    datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    item.dateCreated = datePicker.date
  }
}
