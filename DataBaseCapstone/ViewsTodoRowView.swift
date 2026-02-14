//
//  TodoRowView.swift
//  DataBaseCapstone
//
//  Created by Mendez on 2/9/26.
//

import SwiftUI

struct TodoRowView: View {
    let item: TodoItem
    let isSelected: Bool
    let isEditMode: Bool
    let onToggleComplete: () -> Void
    let onToggleSelection: () -> Void
    
    @State private var scale: CGFloat = 1.0
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 16) {
            // Selection checkbox (in edit mode) - LEFT
            if isEditMode {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(
                        isSelected 
                        ? LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                        : LinearGradient(colors: [.gray], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            onToggleSelection()
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
            }
            
            // Content - MIDDLE
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.body.weight(.medium))
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)
                    .strikethrough(item.isCompleted, color: .secondary)
                
                if !item.notes.isEmpty {
                    Text(item.notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                Text(item.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
            
            // Completion checkbox - RIGHT
            Button {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    scale = 0.8
                    onToggleComplete()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                        scale = 1.0
                    }
                }
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(
                        item.isCompleted 
                        ? LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
                        : LinearGradient(colors: [.gray.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
            }
            .buttonStyle(.plain)
            .scaleEffect(scale)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isSelected && isEditMode 
                    ? LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    : LinearGradient(colors: [.clear], startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 2
                )
        )
    }
}

#Preview {
    VStack {
        TodoRowView(
            item: TodoItem(title: "Sample Task", notes: "This is a note"),
            isSelected: false,
            isEditMode: false,
            onToggleComplete: {},
            onToggleSelection: {}
        )
        
        TodoRowView(
            item: TodoItem(title: "Completed Task", notes: "", isCompleted: true),
            isSelected: false,
            isEditMode: false,
            onToggleComplete: {},
            onToggleSelection: {}
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
