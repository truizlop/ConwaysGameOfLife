public enum ConwayAction {
    case stepSimulation
}

public func conwayReducer(state: [[Cell]], action: ConwayAction) -> [[Cell]] {
    switch action {
    case .stepSimulation: return gameOfLife(state)
    }
}
