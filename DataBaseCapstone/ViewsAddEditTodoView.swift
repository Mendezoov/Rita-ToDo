//
//  AddEditTodoView.swift
//  DataBaseCapstone
//
//  Created by Mendez on 2/9/26.
//

import SwiftUI

struct AddEditTodoView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: TodoViewModel
    
    var itemToEdit: TodoItem?
    
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    
    var isEditMode: Bool {
        itemToEdit != nil
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Adaptive gradient background
                LinearGradient(
                    colors: colorScheme == .dark ? [
                        Color(red: 0.05, green: 0.05, blue: 0.08),
                        Color(red: 0.08, green: 0.05, blue: 0.1)
                    ] : [
                        Color(red: 0.95, green: 0.97, blue: 1.0),
                        Color(red: 0.98, green: 0.95, blue: 1.0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Title field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                        
                        TextField("Enter task title", text: $title)
                            .textFieldStyle(.plain)
                            .padding()
                            .glassEffect(.regular, in: .rect(cornerRadius: 16))
                    }
                    
                    // Notes field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes (Optional)")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                        
                        ZStack(alignment: .topLeading) {
                            if notes.isEmpty {
                                Text("Add notes here...")
                                    .foregroundStyle(.tertiary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 16)
                            }
                            
                            TextEditor(text: $notes)
                                .frame(height: 120)
                                .padding(8)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                        }
                        .glassEffect(.regular, in: .rect(cornerRadius: 16))
                    }
                    
                    Spacer()
                }
                .padding()
                .scaleEffect(scale)
                .opacity(opacity)
            }
            .navigationTitle(isEditMode ? "Edit Task" : "New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                    .foregroundStyle(.red)
              //   .buttonStyle(.glassProminent)
                    
                    
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        saveItem()
                    } label: {
                        Text(isEditMode ? "Update" : "Add")
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .onAppear {
            if let item = itemToEdit {
                title = item.title
                notes = item.notes
            }
            
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
    
    private func saveItem() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        guard !trimmedTitle.isEmpty else { return }
        
        if let item = itemToEdit {
            viewModel.updateItem(item, title: trimmedTitle, notes: notes)
        } else {
            viewModel.addItem(title: trimmedTitle, notes: notes)
        }
        
        dismiss()
    }
}

#Preview {
    AddEditTodoView(viewModel: TodoViewModel())
}
