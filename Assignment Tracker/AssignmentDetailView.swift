//
//  AssignmentDetailView.swift
//  Assignment Tracker
//
//  Created by Michael Sault on 2026-09-04.
//

import SwiftUI

struct AssignmentDetailView: View {
    @Binding var assignment: Assignment
    let onAssignmentError: (AssignmentError) -> Void
    let store: AssignmentStore
    
    var body: some View {
        switch assignment.status {
            case .completed:
                Text(assignment.name).strikethrough()
            case .inProgress:
                Text(assignment.name).bold()
            case .notStarted:
                Text(assignment.name)
        }
        
        Text("Assigned to: \(assignment.assignedTo)")
        Text("\(assignment.effortHours, specifier: "%.2f") hours")
        
        switch assignment.aiMode {
            case .green:
                Text("GREEN").foregroundStyle(Color.green)
            case .amber:
                Text("AMBER").foregroundStyle(.orange)
            case .red:
                Text("RED").foregroundStyle(.red)
        }
        
        if let notes = assignment.notes {
            DisclosureGroup("Show Details") {
                Text(notes)
            } .frame(maxWidth: 220)
        }
        
        switch assignment.status {
            case .notStarted:
                Button("Start") {
                    do {
                        try assignment.validateAssignedTo()
                        assignment.status = .inProgress
                    } catch let error as AssignmentError{
                        onAssignmentError(error)
                    } catch {
                        
                    }
                    
                }
                .buttonStyle(.bordered)
                .accessibilityValue("Not started")
            case .inProgress:
                Button("Complete") {
                    assignment.status = .completed
                    store.saveAssignments()
                }
                .buttonStyle(.bordered)
                .accessibilityValue("In progress")
            case .completed:
                Button("Undo") {
                    assignment.status = .notStarted
                    store.saveAssignments()
                }
                .buttonStyle(.bordered)
                .accessibilityValue("Completed")
        }
    }
}
