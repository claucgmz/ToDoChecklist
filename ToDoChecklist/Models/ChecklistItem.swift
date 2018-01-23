//
//  ChecklistItem.swift
//  ToDoChecklist
//
//  Created by Caludia Carrillo on 1/16/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation
import UserNotifications

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
  
  deinit {
    removeNotification()
  }
  
  func toogleCheckmark() {
    self.checked = !checked
  }
  
  func scheduleNotification() {
    removeNotification()
    if shouldRemind && dueDate > Date() {
      let content = UNMutableNotificationContent()
      content.title = "Reminder:"
      content.body = text
      content.sound = UNNotificationSound.default()
      
      let calendar = Calendar(identifier: .gregorian)
      let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
      let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
      let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
      let center = UNUserNotificationCenter.current()
      center.add(request)
      print("Scheduled: \(request) for itemID: \(itemID)")
    }
  }
  
  private func removeNotification() {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
  }
}
