public enum Pattern {
    case blinker
    case block
    case tub
    case boat
    case glider
    
    private var positions: [(Int, Int)] {
        switch self {
        case .blinker: return [(5, 4), (5, 5), (5, 6)]
        case .block: return [(5, 4), (5, 5), (6, 4), (6, 5)]
        case .tub: return [(5, 4), (4, 5), (5, 6), (6, 5)]
        case .boat: return [(4, 4), (5, 4), (4, 5), (5, 6), (6, 5)]
        case .glider: return [(4, 4), (4, 5), (4, 6), (5, 4), (6, 5)]
        }
    }
    
    private var deadCells: [[Cell]] {
        Array(repeating: Array(repeating: Cell.dead, count: 10), count: 10)
    }
    
    public var grid: [[Cell]] {
        var initial = deadCells
        let positions = self.positions
        positions.forEach { p in initial[p.0][p.1] = .alive }
        return initial
    }
}
