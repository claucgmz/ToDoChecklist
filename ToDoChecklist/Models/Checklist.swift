//
//  Checklist.swift
//  ToDoChecklist
//
//  Created by Caludia Carrillo on 1/20/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

class Checklist: NSObject, Codable {
  var name = ""
  var iconName = "No Icon"
  var items = [ChecklistItem]()
  
  func countUncheckedItems() -> Int {
    return items.reduce(0) {count, item in
      count + (item.checked ? 0 : 1)
    }
  }
}
