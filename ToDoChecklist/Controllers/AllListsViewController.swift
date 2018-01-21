//
//  AllListsViewController.swift
//  ToDoChecklist
//
//  Created by Caludia Carrillo on 1/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {
  func makeCell(for tableView: UITableView) -> UITableViewCell {
    let cellIdentifier = "Cell"
    if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
      return cell
    } else {
      return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    }
  }
}

// MARK: - Table Delegate Methods
extension AllListsViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "ShowChecklist", sender: nil)
  }
}

// MARK: - Table Data Source Methods
extension AllListsViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = makeCell(for: tableView)
    cell.textLabel!.text = "List \(indexPath.row)"
    return cell
  }
}
