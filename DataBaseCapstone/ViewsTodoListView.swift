//
//  TodoListView.swift
//  DataBaseCapstone
//
//  Created by Mendez on 2/9/26.
//

import SwiftUI
import SwiftData

struct TodoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodoItem.createdAt, order: .reverse) private var items: [TodoItem]
    
    @StateObject private var viewModel = TodoViewModel()
    @State private var showingAddSheet = false
    @State private var itemToEdit: TodoItem?
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.97, blue: 1.0),
                        Color(red: 0.98, green: 0.95, blue: 1.0),
                        Color(red: 1.0, green: 0.96, blue: 0.95)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if items.isEmpty {
                        emptyStateView
                    } else {
                        todoListContent
                    }
                }
            }
            .navigationTitle("Rita To-Do ✨")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if !items.isEmpty {
                        Button {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                viewModel.isEditMode.toggle()
                                if !viewModel.isEditMode {
                                    viewModel.deselectAll()
                                }
                            }
                        } label: {
                            Text(viewModel.isEditMode ? "Done" : "Edit")
                                .fontWeight(.semibold)
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isEditMode && !items.isEmpty {
                        Menu {
                            Button {
                                viewModel.selectAll(items)
                            } label: {
                                Label("Select All", systemImage: "checkmark.circle")
                            }
                            
                            Button {
                                viewModel.deselectAll()
                            } label: {
                                Label("Deselect All", systemImage: "circle")
                            }
                            
                            if !viewModel.selectedItems.isEmpty {
                                Divider()
                                
                                Button(role: .destructive) {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                        viewModel.deleteSelectedItems(items)
                                    }
                                } label: {
                                    Label("Delete Selected", systemImage: "trash")
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                addButton
            }
            .sheet(isPresented: $showingAddSheet) {
                AddEditTodoView(viewModel: viewModel)
            }
            .sheet(item: $itemToEdit) { item in
                AddEditTodoView(viewModel: viewModel, itemToEdit: item)
            }
            .onAppear {
                viewModel.modelContext = modelContext
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Text("📝")
                .font(.system(size: 80))
                .rotationEffect(.degrees(rotationAngle))
                .onAppear {
                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        rotationAngle = 15
                    }
                }
            
            Text("No tasks yet!")
                .font(.title2.bold())
                .foregroundStyle(.secondary)
            
            Text("Tap the + button to add your first task")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var todoListContent: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    TodoRowView(
                        item: item,
                        isSelected: viewModel.selectedItems.contains(item.id),
                        isEditMode: viewModel.isEditMode,
                        onToggleComplete: {
                            viewModel.toggleComplete(item)
                        },
                        onToggleSelection: {
                            viewModel.toggleSelection(item.id)
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8, anchor: .bottom)
                            .combined(with: .opacity)
                            .combined(with: .move(edge: .top)),
                        removal: .scale(scale: 0.8, anchor: .center)
                            .combined(with: .opacity)
                    ))
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(index) * 0.05), value: items.count)
                    .onTapGesture {
                        if viewModel.isEditMode {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                viewModel.toggleSelection(item.id)
                            }
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                viewModel.deleteItem(item)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        
                        Button {
                            itemToEdit = item
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
            .padding()
        }
    }
    
    private var addButton: some View {
        Button {
            showingAddSheet = true
        } label: {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.4, green: 0.2, blue: 0.8),
                                Color(red: 0.6, green: 0.3, blue: 0.8),
                                Color(red: 0.8, green: 0.4, blue: 0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)
                    .shadow(color: Color(red: 0.5, green: 0.3, blue: 0.8).opacity(0.4), radius: 15, x: 0, y: 8)
                
                Image(systemName: "plus")
                    .font(.title.bold())
                    .foregroundStyle(.white)
            }
        }
        .padding(.trailing, 24)
        .padding(.bottom, 24)
        .scaleEffect(showingAddSheet ? 0.9 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingAddSheet)
    }
}

#Preview {
    TodoListView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
