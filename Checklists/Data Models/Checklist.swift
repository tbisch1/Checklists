//
//  Checklist.swift
//  Checklists
//
//  Created by Tyler Bischoff on 1/27/22.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]()
    var iconName = "No Icon"
    
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        return items.reduce(0) {cnt, item in cnt + (item.checked ? 0 : 1)}
    }
}
