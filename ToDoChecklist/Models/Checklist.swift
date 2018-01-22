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
  var items = [ChecklistItem]()
}
