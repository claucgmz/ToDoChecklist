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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.delegate = self
    guard let index = dataModel?.indexOfSelectedChecklist, index > -1, let totalList = dataModel?.lists.count else {
      return
    }
    
    if  totalList > index {
      let checklist = dataModel?.lists[index]
      performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
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
      let totalItemsUnchecked = checklist?.countUncheckedItems()
      
      if checklist?.items.count == 0 {
        checklistCell.detailTextLabel?.text = "No items"
      }
      else if totalItemsUnchecked == 0 {
        checklistCell.detailTextLabel?.text = "All Done!"
      }
      else {
        checklistCell.detailTextLabel?.text = "\(totalItemsUnchecked ?? 0 ) unchecked"
      }
      
      return checklistCell
    }
    
    return cell!
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    dataModel?.indexOfSelectedChecklist = indexPath.row
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
    dataModel?.lists.append(checklist)
    reloadTable()
  }
  
  private func editChecklist(_ checklist: Checklist) {
    reloadTable()
  }
  
  private func reloadTable() {
    dataModel?.sortChecklists()
    tableView.reloadData()
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

// MARK: - UINavigationControllerDelegate methods
extension AllListsViewController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    if viewController === self {
      dataModel?.indexOfSelectedChecklist = -1
    }
  }
}
