//
//  TodoViewModel.swift
//  DataBaseCapstone
//
//  Created by Mendez on 2/9/26.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

@MainActor
class TodoViewModel: ObservableObject {
    @Published var selectedItems: Set<UUID> = []
    @Published var isEditMode: Bool = false
    
    var modelContext: ModelContext?
    
    func addItem(title: String, notes: String = "") {
        guard !title.isEmpty, let context = modelContext else { return }
        
        let newItem = TodoItem(title: title, notes: notes)
        context.insert(newItem)
        
        do {
            try context.save()
        } catch {
            print("Failed to save item: \(error)")
        }
    }
    
    func updateItem(_ item: TodoItem, title: String, notes: String) {
        guard let context = modelContext else { return }
        
        item.title = title
        item.notes = notes
        
        do {
            try context.save()
        } catch {
            print("Failed to update item: \(error)")
        }
    }
    
    func toggleComplete(_ item: TodoItem) {
        guard let context = modelContext else { return }
        
        item.isCompleted.toggle()
        
        do {
            try context.save()
        } catch {
            print("Failed to toggle item: \(error)")
        }
    }
    
    func deleteItem(_ item: TodoItem) {
        guard let context = modelContext else { return }
        
        context.delete(item)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete item: \(error)")
        }
    }
    
    func deleteSelectedItems(_ items: [TodoItem]) {
        guard let context = modelContext else { return }
        
        let itemsToDelete = items.filter { selectedItems.contains($0.id) }
        
        for item in itemsToDelete {
            context.delete(item)
        }
        
        do {
            try context.save()
            selectedItems.removeAll()
        } catch {
            print("Failed to delete selected items: \(error)")
        }
    }
    
    func toggleSelection(_ id: UUID) {
        if selectedItems.contains(id) {
            selectedItems.remove(id)
        } else {
            selectedItems.insert(id)
        }
    }
    
    func selectAll(_ items: [TodoItem]) {
        selectedItems = Set(items.map { $0.id })
    }
    
    func deselectAll() {
        selectedItems.removeAll()
    }
}
