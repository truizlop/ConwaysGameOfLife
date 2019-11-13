import Foundation

public enum Cell {
    case alive
    case dead
}

extension Cell: CustomStringConvertible {
    public var description: String {
        switch self {
        case .alive: return "🦠"
        case .dead: return "💀"
        }
    }
}
