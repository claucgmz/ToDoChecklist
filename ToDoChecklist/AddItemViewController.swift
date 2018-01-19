//
//  AddItemViewController.swift
//  ToDoChecklist
//
//  Created by Caludia Carrillo on 1/16/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController {
  
  @IBOutlet private var itemNameTextField: UITextField!
  @IBOutlet private var doneBarButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    itemNameTextField.becomeFirstResponder()
  }
  
  // MARK: - Action methods
  
  @IBAction func cancel() {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func done() {
    print("Contents of the text field: \(itemNameTextField.text!)")
    navigationController?.popViewController(animated: true)
    
  }
}

// MARK: - TableView Delegate methods
extension AddItemViewController {
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
}

// MARK: - Textfield Delegate methods
extension AddItemViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let oldText = textField.text!
    let stringRange = Range(range, in:oldText)!
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    
    doneBarButton.isEnabled = !newText.isEmpty

    return true
  }
}
