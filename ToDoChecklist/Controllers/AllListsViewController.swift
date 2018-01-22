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
    tableView.register(UINib(nibName: "ChecklistCell", bundle: nil), forCellReuseIdentifier: "ChecklistCell")
    let checklist = Checklist()
    checklist.name = "Checklist 1"
    lists.append(checklist)
    
    let checklist2 = Checklist()
    checklist2.name = "Checklist 2"
    lists.append(checklist2)
  }
}

// MARK: - TableView Data Source methods
extension AllListsViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return lists.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell") as? ChecklistCell
    let checklist = lists[indexPath.row]
    
    if let checklistCell = cell {
      checklistCell.textLabel?.text = checklist.name
      return checklistCell
    }
    
    return cell!
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let checklist = lists[indexPath.row]
    performSegue(withIdentifier: "ShowChecklist", sender: checklist)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowChecklist" {
      let controller = segue.destination as! ChecklistViewController
      controller.checklist = (sender as! Checklist)
    }
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
