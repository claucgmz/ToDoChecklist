//
//  IconPickerViewController.swift
//  ToDoChecklist
//
//  Created by Caludia Carrillo on 1/22/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
  func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
  weak var delegate: IconPickerViewControllerDelegate?
  let icons = ["No Icon", "Appointments", "Birthdays", "Chores", "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "IconCell", bundle: nil), forCellReuseIdentifier: "IconCell")
  }
}

// MARK: - Table View Delegates
extension IconPickerViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return icons.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath) as? IconCell
    let iconName = icons[indexPath.row]
    
    if let iconCell = cell {
      iconCell.imageView?.image = UIImage(named: iconName)
      iconCell.textLabel?.text = iconName
    }

    return cell!
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let delegate = delegate {
      let iconName = icons[indexPath.row]
      delegate.iconPicker(self, didPick: iconName)
    }
  }
}
