//
//  ItemDetailViewController.swift
//  ToDoChecklist
//
//  Created by Caludia Carrillo on 1/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import UserNotifications

protocol ItemDetailViewControllerDelegate: class {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController {
  
  @IBOutlet private var itemNameTextField: UITextField!
  @IBOutlet private var doneBarButton: UIBarButtonItem!
  
  @IBOutlet private var shouldRemindSwitch: UISwitch!
  @IBOutlet private var dueDateLabel: UILabel!
  
  @IBOutlet private var datePickerCell: UITableViewCell!
  @IBOutlet private var datePicker: UIDatePicker!
  
  weak var delegate: ItemDetailViewControllerDelegate?
  var itemToEdit: ChecklistItem?
  private var dueDate = Date()
  private var datePickerIsVisible = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let itemToEdit = itemToEdit {
      title = "Edit Item"
      itemNameTextField.text = itemToEdit.text
      doneBarButton.isEnabled = true
      shouldRemindSwitch.isOn = itemToEdit.shouldRemind
      dueDate = itemToEdit.dueDate
    }
    
    updateDueDateLabel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    itemNameTextField.becomeFirstResponder()
  }
  
  // MARK: - Private methods
  private func updateDueDateLabel() {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    dueDateLabel.text = formatter.string(from: dueDate)
  }
  
  private func showDatePicker() {
    datePickerIsVisible = true
    
    let indexPathDateRow = IndexPath(row: 1, section: 1)
    let indexPathDatePicker = IndexPath(row: 2, section: 1)
    
    if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
      dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
    }
    
    tableView.beginUpdates()
    tableView.insertRows(at: [indexPathDatePicker], with: .fade)
    tableView.reloadRows(at: [indexPathDateRow], with: .none)
    tableView.endUpdates()
    
    datePicker.setDate(dueDate, animated: false)
  }
  
  private func hideDatePicker() {
    
    if datePickerIsVisible {
      datePickerIsVisible = false
      
      let indexPathDateRow = IndexPath(row: 1, section: 1)
      let indexPathDatePicker = IndexPath(row: 2, section: 1)
      
      if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
        dateCell.detailTextLabel!.textColor = .black
      }
      
      tableView.beginUpdates()
      tableView.reloadRows(at: [indexPathDateRow], with: .none)
      tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
      tableView.endUpdates()
    }

  }
  
  // MARK: - Action methods
  
  @IBAction func cancel() {
    delegate?.itemDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    if let itemToEdit = itemToEdit {
      itemToEdit.text = itemNameTextField.text!
      itemToEdit.dueDate = dueDate
      itemToEdit.shouldRemind = shouldRemindSwitch.isOn
      itemToEdit.scheduleNotification()
      delegate?.itemDetailViewController(self, didFinishEditing: itemToEdit)
    }
    else {
      let item = ChecklistItem()
      item.text = itemNameTextField.text!
      item.dueDate = dueDate
      item.shouldRemind = shouldRemindSwitch.isOn
      item.checked = false
      item.scheduleNotification()
      delegate?.itemDetailViewController(self, didFinishAdding: item)
    }
    
  }
  
  @IBAction func dateChanged(_ datePicker: UIDatePicker) {
    dueDate = datePicker.date
    updateDueDateLabel()
  }
  
  @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
    itemNameTextField.resignFirstResponder()
    if switchControl.isOn {
      let center = UNUserNotificationCenter.current()
      center.requestAuthorization(options: [.alert, .sound]) {
        granted, error in
        // do nothing
      } }
  }
}

// MARK: - TableView Delegate methods
extension ItemDetailViewController {
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if indexPath.section == 1 && indexPath.row == 1 {
      return indexPath
    }
    else{
      return nil
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 1 && indexPath.row == 2 {
      return datePickerCell
    }
    else {
      return super.tableView(tableView, cellForRowAt: indexPath)
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 1 && datePickerIsVisible {
      return 3
    }
    else {
      return super.tableView(tableView, numberOfRowsInSection: section)
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 1 && indexPath.row == 2 {
      return 217
    }
    else {
      return super.tableView(tableView, heightForRowAt: indexPath)
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    itemNameTextField.resignFirstResponder()
    
    if indexPath.section == 1 && indexPath.row == 1 {
      if !datePickerIsVisible {
        showDatePicker()
      }
      else {
        hideDatePicker()
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
    var newIndexPath = indexPath
    
    if indexPath.section == 1 && indexPath.row == 2 {
      newIndexPath = IndexPath(row: 0, section: indexPath.section)
    }
    
    return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
  }
}

// MARK: - Textfield Delegate methods
extension ItemDetailViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let oldText = textField.text!
    let stringRange = Range(range, in:oldText)!
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    
    doneBarButton.isEnabled = !newText.isEmpty
    
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    hideDatePicker()
  }
}
