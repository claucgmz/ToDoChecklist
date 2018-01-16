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
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Private methods
  private func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
    if item.checked {
      cell.accessoryType = .checkmark
    }
    else {
      cell.accessoryType = .none
    }
  }
  
  @IBAction func addItem() {
    let newRowIndex = items.count
    let item = ChecklistItem()
    item.text = "Another item"
    item.checked = false
    
    items.append(item)
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
  }
}

// MARK: - TableView Data Source methods
extension ChecklistViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    let item = items[indexPath.row]
    configureCheckmark(for: cell, with: item)
    return cell
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
    
    configureCheckmark(for: cell, with: item)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
