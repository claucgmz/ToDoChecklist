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
    
    loadChecklists()
  }
  
  func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("Checklist.plist")
  }
  
  func saveChecklists() {
    let encoder = PropertyListEncoder()
    do {
      let data = try encoder.encode(lists)
      try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
    } catch {
      print("Error encoding item array!")
    }
  }
  
  func loadChecklists() {
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path) {
      let decoder = PropertyListDecoder()
      do {
        lists = try decoder.decode([Checklist].self, from: data)
      } catch {
        print("Error decoding item array!")
      }
    }
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
            controller.checklistToEdit = lists[indexPath.row]
          }
        }
      }
      
      // MARK: - Private methods
      private func addChecklist(_ checklist: Checklist) {
        let newRowIndex = lists.count
        lists.append(checklist)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
      }
      
      private func editChecklist(_ checklist: Checklist) {
        if let index = lists.index(of: checklist) {
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
        lists.remove(at: indexPath.row)
        
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
