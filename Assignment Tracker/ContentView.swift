//
//  ContentView.swift
//  Assignment Tracker
//
//  Created by Michael Sault on 2026-09-01.
//

import SwiftUI

struct ContentView: View {
    @State private var showAlert = false
    
    @State private var assignments = AssignmentStore()
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "swift")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, \(assignments.assignments[0].assignedTo)").font(Font.largeTitle)
                    .padding()
                
                ForEach($assignments.assignments) { $assignment in
                    AssignmentRow(assignment: $assignment, onAssignmentError: { showAlert = true}, store: assignments )
                    NavigationLink {
                        AssignmentDetailView(assignment: $assignment, onAssignmentError: { error in
                                showAlert = true
                            },
                            store: assignments
                        )
                    } label: {
                        Text("View Details")
                    }
                }
                
            }
            .padding()
        } .alert("Assignment can not be started as it is not assigned to anyone", isPresented: $showAlert) {
            Button("OK") {}
        }
    }
}

#Preview {
    ContentView()
}
