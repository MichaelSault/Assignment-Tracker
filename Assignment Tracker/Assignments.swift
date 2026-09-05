//
//  Assignments.swift
//  Assignment Tracker
//
//  Created by Michael Sault on 2026-09-04.
//

import SwiftUI

struct Assignment: Identifiable, Codable {
    let id: UUID
    
    var name: String
    var assignedTo: String
    var effort: Int
    var effortHours: Double {
        return Double(effort)/60
    }
    var notes: String?
    var aiMode: AIMode
    var status: Status
    
    func validateAssignedTo() throws {
        if (assignedTo.isEmpty) {
            throw AssignmentError.notAssigned
        }
    }
}

enum AIMode: Codable{
    case green
    case amber
    case red
}

enum Status: Codable{
    case notStarted
    case inProgress
    case completed
}

enum AssignmentError: Error {
    case notAssigned
}



struct AssignmentRow: View {
    @Binding var assignment: Assignment
    let onAssignmentError: () -> Void
    let store: AssignmentStore

    var body: some View {
        if (assignment.status == Status.completed) {
            Text(assignment.name).strikethrough()
        } else if (assignment.status == Status.inProgress) {
            Text(assignment.name).bold()
        } else {
            Text(assignment.name)
        }
        
        Text("\(assignment.effortHours, specifier: "%.2f") hours")
        
        if (assignment.aiMode == AIMode.green) {
            Text("GREEN").foregroundStyle(Color.green)
        } else if (assignment.aiMode == AIMode.amber) {
            Text("AMBER").foregroundStyle(.orange)
        } else {
            Text("RED").foregroundStyle(.red)
        }
        
        if let notes = assignment.notes {
            DisclosureGroup("Show Details") {
                Text(notes)
            } .frame(maxWidth: 220)
        }
        
        if (assignment.status == Status.notStarted) {
            Button("Start") {
                do {
                    try assignment.validateAssignedTo()
                    assignment.status = .inProgress
                    store.saveAssignments()
                } catch {
                    onAssignmentError()
                }
                
            }
            .buttonStyle(.bordered)
        } else if (assignment.status == Status.inProgress){
            Button("Complete") {
                assignment.status = .completed
                store.saveAssignments()
            }
            .buttonStyle(.bordered)
        } else if (assignment.status == Status.completed){
            Button("Undo") {
                assignment.status = .notStarted
                store.saveAssignments()
            }
            .buttonStyle(.bordered)
        }
        
        
        Spacer().frame(height: 30)
    }
    
}
