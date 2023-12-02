import Foundation
import SwiftData
import SwiftUI


extension ModelContainer {
    static var populatedPreviewContainer: ModelContainer? {
        do {
            let container = try ModelContainer(for: Lift.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
            
            Task { @MainActor in
                let context = container.mainContext
                
                let deadlift = Lift.template(for: .deadlift)
                
                context.insert(deadlift)
                context.insert(Lift.template(for: .bench))
                context.insert(Lift.template(for: .overheadPress))
                
                let workout1 = Workout.getLoggedWorkout(weight: 140, date: Date().subtracting(days: 2), lift: deadlift)
                let workout2 = Workout.getLoggedWorkout(weight: 150, date: Date(), lift: deadlift)
                
                context.insert(workout1)
                context.insert(workout2)
                
                return container
            }
            return container
        } catch {
            fatalError("failed to create preview container")
        }
    }
}


extension View {
    func populatedPreviewContainer() -> some View {
        modelContainer(.populatedPreviewContainer!)
    }
    func emptyPreviewContainer() -> some View {
        modelContainer(for: [Lift.self, Set.self, Workout.self], inMemory: true)
    }
}
