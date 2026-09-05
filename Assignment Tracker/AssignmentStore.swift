//
//  AssignmentStore.swift
//  Assignment Tracker
//
//  Created by Michael Sault on 2026-09-05.
//

import Observation
import Foundation

@Observable
class AssignmentStore {
    var assignments: [Assignment] = [
        Assignment(id: UUID(), name: "Assignment1", assignedTo: "Madeleine", effort: 90, notes: "this is the first assignment", aiMode: AIMode.amber, status: Status.inProgress, ),
        Assignment(id: UUID(), name: "Assignment2", assignedTo: "", effort: 30, aiMode: AIMode.red, status: Status.notStarted),
        Assignment(id: UUID(), name: "Assignment3", assignedTo: "Madeleine", effort: 120, aiMode: AIMode.green, status: Status.notStarted),
    ]
    
    init() {
        loadAssignments()
    }
    
    private var saveURL: URL {
        let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        return documentsDirectory.appendingPathComponent("assignments.json")
    }

    func saveAssignments() {
        do {
            let data = try JSONEncoder().encode(assignments)
            try data.write(to: saveURL)
        } catch {
            print("Failed to encode assignments: \(error)")
        }
    }
    
    func loadAssignments() {
        do {
            let data = try Data(contentsOf: saveURL)
            assignments = try JSONDecoder().decode([Assignment].self, from: data)
        } catch {
            print("No saved assignments yet, or loading failed: \(error)")
        }
    }
    
    
    
}


