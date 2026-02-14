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
    @Environment(\.colorScheme) private var colorScheme
    @Query(sort: \TodoItem.createdAt, order: .reverse) private var items: [TodoItem]
    
    @StateObject private var viewModel = TodoViewModel()
    @State private var showingAddSheet = false
    @State private var rotationAngle: Double = 0
    @State private var selectedItems: Set<UUID> = []
    
    var isSelectMode: Bool {
        !selectedItems.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Adaptive gradient background
                LinearGradient(
                    colors: colorScheme == .dark ? [
                        Color(red: 0.05, green: 0.05, blue: 0.08),
                        Color(red: 0.08, green: 0.05, blue: 0.1),
                        Color(red: 0.1, green: 0.06, blue: 0.08)
                    ] : [
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
                if isSelectMode {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedItems.removeAll()
                            }
                        } label: {
                            Text("Cancel")
                                .fontWeight(.semibold)
                                .foregroundStyle(.red)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedItems = Set(items.map { $0.id })
                                }
                            } label: {
                                Label("Select All", systemImage: "checkmark.circle")
                            }
                            
                            Divider()
                            
                            Button(role: .destructive) {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                    deleteSelectedItems()
                                }
                            } label: {
                                Label("Delete \(selectedItems.count) Item\(selectedItems.count == 1 ? "" : "s")", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
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
        List {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                TodoRowView(
                    item: item,
                    isSelected: selectedItems.contains(item.id),
                    isEditMode: isSelectMode,
                    onToggleComplete: {
                        viewModel.toggleComplete(item)
                    },
                    onToggleSelection: {
                        toggleSelection(item.id)
                    }
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                .contentShape(Rectangle())
                .onTapGesture {
                    // Only toggle selection if we're NOT in select mode yet
                    // Or if we are in select mode
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        toggleSelection(item.id)
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            viewModel.deleteItem(item)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                }
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.8, anchor: .bottom)
                        .combined(with: .opacity)
                        .combined(with: .move(edge: .top)),
                    removal: .scale(scale: 0.8, anchor: .center)
                        .combined(with: .opacity)
                ))
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    private var addButton: some View {
        Button {
            showingAddSheet = true
        } label: {
            Image(systemName: "plus")
                .font(.title.bold())
                .foregroundStyle(.white)
                .frame(width: 70, height: 70)
        }
        .glassEffect(.regular.tint(colorScheme == .dark ? 
            Color(red: 0.6, green: 0.4, blue: 0.9) : 
            Color(red: 0.5, green: 0.3, blue: 0.8)).interactive(), in: .circle)
        .padding(.trailing, 24)
        .padding(.bottom, 24)
        .scaleEffect(showingAddSheet ? 0.9 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingAddSheet)
        .shadow(
            color: Color(red: 0.5, green: 0.3, blue: 0.8).opacity(colorScheme == .dark ? 0.6 : 0.4),
            radius: 15,
            x: 0,
            y: 8
        )
    }
    
    // MARK: - Helper Functions
    
    private func toggleSelection(_ id: UUID) {
        if selectedItems.contains(id) {
            selectedItems.remove(id)
        } else {
            selectedItems.insert(id)
        }
    }
    
    private func deleteSelectedItems() {
        for item in items where selectedItems.contains(item.id) {
            viewModel.deleteItem(item)
        }
        selectedItems.removeAll()
    }
}

#Preview {
    TodoListView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
