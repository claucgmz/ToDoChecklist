//
//  ChecklistItem.swift
//  ToDoChecklist
//
//  Created by Caludia Carrillo on 1/16/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, Codable {
  var text = ""
  var checked = false
  
  func toogleCheckmark() {
    self.checked = !checked
  }
}
