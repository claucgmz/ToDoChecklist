//
//  ChecklistViewController.swift
//  ToDoChecklist
//
//  Created by Caludia Carrillo on 1/16/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
  var checklist: Checklist?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = checklist?.name
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddItem" {
      let controller = segue.destination as! ItemDetailViewController
      controller.delegate = self
    }
  }
  
  private func addItem(_ item: ChecklistItem) {
    let newRowIndex = checklist?.items.count
    checklist?.items.append(item)
    
    guard let index = newRowIndex else {
      return
    }
    let indexPath = IndexPath(row: index, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
  }
  
  private func editItem(_ item: ChecklistItem) {
    if let index = checklist?.items.index(of: item) {
      let indexPath = IndexPath(row: index, section: 0)
      if let cell = tableView.cellForRow(at: indexPath) as? ChecklistItemCell {
        cell.itemNameLabel.text = item.text
      }
    }
  }
}

// MARK: - TableView Data Source methods
extension ChecklistViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return checklist?.items.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItemCell") as? ChecklistItemCell
    let item = checklist?.items[indexPath.row]
    
    if let checklistCell = cell, let item = item {
      configureCheckmark(for: checklistCell, with: item)
      checklistCell.itemNameLabel.text = item.text
      return checklistCell
    }
    
    return cell!
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    checklist?.items.remove(at: indexPath.row)
    
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
    
    if let item = checklist?.items[indexPath.row] {
      item.toogleCheckmark()
      configureCheckmark(for: (cell as? ChecklistItemCell)!, with: item)
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    if let editItemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailVC") as? ItemDetailViewController {
      editItemVC.delegate = self
      editItemVC.itemToEdit = checklist?.items[indexPath.row]
      navigationController?.pushViewController(editItemVC, animated: true)
    }
  }
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
    navigationController?.popViewController(animated:true)
  }
  
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
    addItem(item)
    navigationController?.popViewController(animated:true)
  }
  
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
    editItem(item)
    navigationController?.popViewController(animated: true)
  }
}
