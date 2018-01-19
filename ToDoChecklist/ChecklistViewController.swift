//
//  ChecklistViewController.swift
//  ToDoChecklist
//
//  Created by Caludia Carrillo on 1/16/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
  private var items = [ChecklistItem]()
  
  required init?(coder aDecoder: NSCoder) {
    
    let checklistItem = ChecklistItem()
    checklistItem.text = "My first to-do"
    checklistItem.checked = false
    items.append(checklistItem)
    
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "ChecklistItemCell", bundle: nil), forCellReuseIdentifier: "ChecklistItemCell")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Private methods
  private func configureCheckmark(for cell: ChecklistItemCell, with item: ChecklistItem) {
    if item.checked {
      cell.checkmarkLabel.text = "✔️"
    }
    else {
      cell.checkmarkLabel.text = ""
    }
  }
  
  private func addItem(_ item: ChecklistItem) {
    let newRowIndex = items.count
    items.append(item)
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddItem" {
      let controller = segue.destination as! AddItemViewController
      controller.delegate = self
    }
  }
}

// MARK: - TableView Data Source methods
extension ChecklistViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItemCell") as? ChecklistItemCell
    let item = items[indexPath.row]
    
    if let checklistCell = cell {
      configureCheckmark(for: checklistCell, with: item)
      cell?.itemNameLabel.text = item.text
      return checklistCell
    }
    
    return cell!
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    items.remove(at: indexPath.row)
    
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
  }
}

// MARK: - TableView Delegate methods
extension ChecklistViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }
    let item = items [indexPath.row]
    item.toogleCheckmark()
    
    configureCheckmark(for: (cell as? ChecklistItemCell)!, with: item)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension ChecklistViewController: AddItemViewControllerDelegate {
  func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
    navigationController?.popViewController(animated:true)
  }
  
  func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem) {
    addItem(item)
    navigationController?.popViewController(animated:true)
  }  
}
