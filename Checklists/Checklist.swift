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
    
    init(name: String) {
        self.name = name
        super.init()
    }
}
