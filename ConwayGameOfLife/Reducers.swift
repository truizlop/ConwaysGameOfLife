public enum ConwayAction {
    case stepSimulation
    case select(Pattern)
}

public func conwayReducer(state: [[Cell]], action: ConwayAction) -> [[Cell]] {
    switch action {
    case .stepSimulation: return gameOfLife(state)
    case let .select(pattern): return pattern.grid
    }
}
