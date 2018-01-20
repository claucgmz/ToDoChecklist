//
//  ItemDetailViewController.swift
//  ToDoChecklist
//
//  Created by Caludia Carrillo on 1/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController {
  
  @IBOutlet private var itemNameTextField: UITextField!
  @IBOutlet private var doneBarButton: UIBarButtonItem!
  
  weak var delegate: ItemDetailViewControllerDelegate?
  var itemToEdit: ChecklistItem?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let itemToEdit = itemToEdit {
      title = "Edit Item"
      itemNameTextField.text = itemToEdit.text
      doneBarButton.isEnabled = true
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    itemNameTextField.becomeFirstResponder()
  }
  
  // MARK: - Action methods
  
  @IBAction func cancel() {
    delegate?.itemDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    if let itemToEdit = itemToEdit {
      itemToEdit.text = itemNameTextField.text!
      delegate?.itemDetailViewController(self, didFinishEditing: itemToEdit)
    }
    else {
      let item = ChecklistItem()
      item.text = itemNameTextField.text!
      item.checked = false
      delegate?.itemDetailViewController(self, didFinishAdding: item)
    }
    
  }
}

// MARK: - TableView Delegate methods
extension ItemDetailViewController {
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
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
}
