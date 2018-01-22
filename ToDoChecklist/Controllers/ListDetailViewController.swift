//
//  ListDetailViewController.swift
//  ToDoChecklist
//
//  Created by Caludia Carrillo on 1/21/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
  func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
  func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
  func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController {
  
  @IBOutlet private weak var doneBarButton: UIBarButtonItem!
  @IBOutlet private weak var checklistNameTextField: UITextField!
  
  weak var delegate: ListDetailViewControllerDelegate?
  var checklistToEdit: Checklist?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let checklistToEdit = checklistToEdit {
      title = "Edit Checklist"
      checklistNameTextField.text = checklistToEdit.name
      doneBarButton.isEnabled = true
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    checklistNameTextField.becomeFirstResponder()
  }
  
  @IBAction func cancel() {
    delegate?.listDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    if let checklistToEdit = checklistToEdit {
      checklistToEdit.name = checklistNameTextField.text!
      delegate?.listDetailViewController(self, didFinishEditing: checklistToEdit)
    }
    else {
      let checklist = Checklist()
      checklist.name = checklistNameTextField.text!
      delegate?.listDetailViewController(self, didFinishAdding: checklist)
    }
  }
}

// MARK: - TableView Delegate methods
extension ListDetailViewController {
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
}

// MARK: - Textfield Data source methods
extension ListDetailViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let oldText = textField.text!
    let stringRange = Range(range, in:oldText)!
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    
    doneBarButton.isEnabled = !newText.isEmpty
    
    return true
  }
}
