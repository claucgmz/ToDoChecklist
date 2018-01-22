//
//  ChecklistViewController.swift
//  ToDoChecklist
//
//  Created by Caludia Carrillo on 1/16/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {
  var dataModel: DataModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "ChecklistCell", bundle: nil), forCellReuseIdentifier: "ChecklistCell")
  }

}

// MARK: - TableView Data Source methods
extension AllListsViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataModel?.lists.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell") as? ChecklistCell
    let checklist = dataModel?.lists[indexPath.row]
    
    if let checklistCell = cell {
      checklistCell.textLabel?.text = checklist?.name
      return checklistCell
    }
    
    return cell!
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let checklist = dataModel?.lists[indexPath.row]
    performSegue(withIdentifier: "ShowChecklist", sender: checklist)
  }
  
  override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }
    performSegue(withIdentifier: "EditChecklist", sender: cell)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowChecklist" {
      let controller = segue.destination as! ChecklistViewController
      controller.checklist = (sender as! Checklist)
    }
    else if segue.identifier == "AddChecklist" {
      let controller = segue.destination as! ListDetailViewController
      controller.delegate = self
    }
    else if segue.identifier == "EditChecklist" {
      let controller = segue.destination as! ListDetailViewController
      controller.delegate = self
      if let indexPath = tableView.indexPath(for: sender as! ChecklistCell) {
        controller.checklistToEdit = dataModel?.lists[indexPath.row]
      }
    }
  }
  
  // MARK: - Private methods
  private func addChecklist(_ checklist: Checklist) {
    let newRowIndex = dataModel?.lists.count
    dataModel?.lists.append(checklist)
    guard let index = newRowIndex else {
      return
    }
    let indexPath = IndexPath(row: index, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
  }
  
  private func editChecklist(_ checklist: Checklist) {
    if let index = dataModel?.lists.index(of: checklist) {
      let indexPath = IndexPath(row: index, section: 0)
      if let cell = tableView.cellForRow(at: indexPath) as? ChecklistCell {
        cell.textLabel?.text = checklist.name
      }
    }
  }
}

// MARK: - TableView Delegate methods
extension AllListsViewController {
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    dataModel?.lists.remove(at: indexPath.row)
    
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
  }
}

// MARK: - ListDetailViewControllerDelegate methods
extension AllListsViewController: ListDetailViewControllerDelegate {
  func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
    navigationController?.popViewController(animated:true)
  }
  
  func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
    addChecklist(checklist)
    navigationController?.popViewController(animated:true)
  }
  
  func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
    editChecklist(checklist)
    navigationController?.popViewController(animated:true)
  }
}
