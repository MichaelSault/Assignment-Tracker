//
//  ContentView.swift
//  Assignment Tracker
//
//  Created by Michael Sault on 2026-09-01.
//

import SwiftUI

struct ContentView: View {
    @State private var showAlert = false
    
    struct Assignment: Identifiable {
        let id = UUID()
        
        var name: String
        var assignedTo: String
        var effort: Int
        var effortHours: Double {
            return Double(effort)/60
        }
        var notes: String?
        var AIMode: AIMode
        var Status: Status
    }
    
    enum AIMode {
        case GREEN
        case AMBER
        case RED
    }
    
    enum Status {
        case notStarted
        case inProgress
        case completed
    }
    
    enum AssignmentError: Error {
        case notAssigned
    }
    
    func validateAssignedTo(assignment: Assignment) throws {
        if (assignment.assignedTo.isEmpty) {
            throw AssignmentError.notAssigned
        }
    }
    
    @State private var assignments: [Assignment] = [
        Assignment(name: "Assignment1", assignedTo: "Madeleine", effort: 90, notes: "this is the first assignment", AIMode: AIMode.AMBER, Status: Status.inProgress, ),
        Assignment(name: "Assignment2", assignedTo: "", effort: 30, AIMode: AIMode.RED, Status: Status.notStarted),
        Assignment(name: "Assignment3", assignedTo: "Madeleine", effort: 120, AIMode: AIMode.GREEN, Status: Status.notStarted),
    ]
    
    var body: some View {
        VStack {
            Image(systemName: "swift")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, \(assignments[0].assignedTo)").font(Font.largeTitle)
                .padding()
            
            ForEach($assignments) { $assignment in
                if (assignment.Status == Status.completed) {
                    Text(assignment.name).strikethrough()
                } else if (assignment.Status == Status.inProgress) {
                    Text(assignment.name).bold()
                } else {
                    Text(assignment.name)
                }
                
                Text("\(assignment.effortHours, specifier: "%.2f") hours")
                
                if (assignment.AIMode == AIMode.GREEN) {
                    Text("GREEN").foregroundStyle(Color.green)
                } else if (assignment.AIMode == AIMode.AMBER) {
                    Text("AMBER").foregroundStyle(.orange)
                } else {
                    Text("RED").foregroundStyle(.red)
                }
                
                if let notes = assignment.notes {
                    DisclosureGroup("Show Details") {
                        Text(notes)
                    } .frame(maxWidth: 220)
                }
                
                if (assignment.Status == Status.notStarted) {
                    Button("Start") {
                        do {
                            try validateAssignedTo(assignment: assignment)
                            assignment.Status = .inProgress
                        } catch {
                            showAlert = true
                        }
                        
                    }
                    .buttonStyle(.bordered)
                } else if (assignment.Status == Status.inProgress){
                    Button("Complete") {
                        assignment.Status = .completed
                    }
                    .buttonStyle(.bordered)
                } else if (assignment.Status == Status.completed){
                    Button("Undo") {
                        assignment.Status = .notStarted
                    }
                    .buttonStyle(.bordered)
                }
                
                
                Spacer().frame(height: 30)
            }
            .alert("Assignment can not be started as it is not assigned to anyone", isPresented: $showAlert) {
                Button("OK") {}
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
