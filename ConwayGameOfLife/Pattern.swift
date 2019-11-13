public enum Pattern: String, CaseIterable {
    case blinker
    case beacon
    case glider
    case toad
    case diehard
    case acorn
    case pentomino
    
    private var positions: [(Int, Int)] {
        switch self {
        case .blinker: return [(5, 4), (5, 5), (5, 6)]
        case .beacon: return [(4, 4), (4, 5), (5, 4), (6, 7), (7, 6), (7, 7)]
        case .glider: return [(4, 4), (4, 5), (4, 6), (5, 4), (6, 5)]
        case .toad: return [(4, 5), (4, 6), (4, 7), (5, 4), (5, 5), (5, 6)]
        case .diehard: return [(4, 7), (5, 1), (5, 2), (6, 2), (6, 6), (6, 7), (6, 8)]
        case .acorn: return [(4, 2), (5, 4), (6, 1), (6, 2), (6, 5), (6, 6), (6, 7)]
        case .pentomino: return [(4, 5), (4, 6), (5, 4), (5, 5), (6, 5)]
        }
    }
    
    private var deadCells: [[Cell]] {
        Array(repeating: Array(repeating: Cell.dead, count: 10), count: 10)
    }
    
    public var title: String { self.rawValue.capitalized }
    
    public var grid: [[Cell]] {
        var initial = deadCells
        let positions = self.positions
        positions.forEach { p in initial[p.0][p.1] = .alive }
        return initial
    }
}
