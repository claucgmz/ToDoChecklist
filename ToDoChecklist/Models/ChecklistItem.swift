//
//  ChecklistItem.swift
//  ToDoChecklist
//
//  Created by Caludia Carrillo on 1/16/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, Codable {
  var itemID: Int
  var text = ""
  var checked = false
  var dueDate = Date()
  var shouldRemind = false
  
  override init() {
    itemID = DataModel.nextChecklistItemId()
    super.init()
  }
  
  func toogleCheckmark() {
    self.checked = !checked
  }
}
