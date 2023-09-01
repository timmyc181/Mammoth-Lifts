import Foundation
import SwiftData
import SwiftUI


extension ModelContainer {
    static var populatedPreviewContainer: ModelContainer? {
        do {
            let container = try ModelContainer(for: Lift.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
            
            Task { @MainActor in
                let context = container.mainContext
                
                context.insert(Lift.template(for: .deadlift))
                context.insert(Lift.template(for: .bench))
                context.insert(Lift.template(for: .overheadPress))
                
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
