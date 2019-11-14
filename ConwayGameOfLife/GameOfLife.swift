import Bow

extension FocusedGrid where A: Monoid {
    public func localSum() -> A {
        let coefficients = ArrayK(-1, 0, 1)
        return ArrayK.zip(coefficients, coefficients)
            .filter { x in x.0 != 0 || x.1 != 0 }
            .map { a in self[self.focus.x + a.0, self.focus.y + a.1] }
            .combineAll()
    }
}

public func gameOfLife(_ state: [[Cell]]) -> [[Cell]] {
    FocusedGrid(focus: (0, 0), grid: state)
        .map(cellToInt)
        .coflatMap(conwayStep)
        .map(intToCell)^
        .grid
}

private func conwayStep(_ grid: FocusedGridOf<Int>) -> Int {
    let liveNeighbors = grid^.localSum()
    let live = grid.extract()
    
    if live == 1 {
        return (liveNeighbors >= 2 && liveNeighbors <= 3) ? 1 : 0
    } else {
        return (liveNeighbors == 3) ? 1 : 0
    }
}

private func cellToInt(_ cell: Cell) -> Int {
    switch cell {
    case .dead: return 0
    case .alive: return 1
    }
}

private func intToCell(_ int: Int) -> Cell {
    int == 0 ? .dead : .alive
}
