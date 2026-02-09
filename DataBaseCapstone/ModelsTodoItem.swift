//
//  TodoItem.swift
//  DataBaseCapstone
//
//  Created by Mendez on 2/9/26.
//

import Foundation
import SwiftData

@Model
final class TodoItem {
    var id: UUID
    var title: String
    var notes: String
    var isCompleted: Bool
    var createdAt: Date
    
    init(title: String, notes: String = "", isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.createdAt = Date()
    }
}
