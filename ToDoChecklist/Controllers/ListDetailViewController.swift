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
  @IBOutlet private weak var iconImageView: UIImageView!
  
  weak var delegate: ListDetailViewControllerDelegate?
  var checklistToEdit: Checklist?
  var iconName = "Folder"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let checklistToEdit = checklistToEdit {
      title = "Edit Checklist"
      iconName = checklistToEdit.iconName
      checklistNameTextField.text = checklistToEdit.name
      doneBarButton.isEnabled = true
    }
    
    iconImageView.image = UIImage(named: iconName)
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
      checklistToEdit.iconName = iconName
      delegate?.listDetailViewController(self, didFinishEditing: checklistToEdit)
    }
    else {
      let checklist = Checklist()
      checklist.name = checklistNameTextField.text!
      checklist.iconName = iconName
      delegate?.listDetailViewController(self, didFinishAdding: checklist)
    }
  }
  
  // MARK: - Navigation methods
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PickIcon" {
      let controller = segue.destination as! IconPickerViewController
      controller.delegate = self
    }
  }
}

// MARK: - TableView Delegate methods
extension ListDetailViewController {
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if indexPath.section == 1 {
      return indexPath
    }
    else {
      return nil
    }
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

// MARK: - IconPickerViewControllerDelegate
extension ListDetailViewController: IconPickerViewControllerDelegate {
  func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
    self.iconName = iconName
    iconImageView.image = UIImage(named: iconName)
    navigationController?.popViewController(animated: true)
  }
}
