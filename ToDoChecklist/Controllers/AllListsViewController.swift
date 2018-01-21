//
//  ChecklistViewController.swift
//  ToDoChecklist
//
//  Created by Caludia Carrillo on 1/16/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {
  private var lists = [Checklist]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "ChecklistItemCell", bundle: nil), forCellReuseIdentifier: "ChecklistItemCell")
    let checklist = Checklist()
    checklist.name = "Checklist 1"
    lists.append(checklist)
  }
}

// MARK: - TableView Data Source methods
extension AllListsViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return lists.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItemCell") as? ChecklistItemCell
    let checklist = lists[indexPath.row]
    
    if let checklistCell = cell {
      checklistCell.itemNameLabel.text = checklist.name
      return checklistCell
    }
    
    return cell!
  }
}

// MARK: - TableView Delegate methods
extension AllListsViewController {
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    lists.remove(at: indexPath.row)
    
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
  }
}
