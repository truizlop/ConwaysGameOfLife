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

public func conwayStep(_ grid: FocusedGridOf<Int>) -> Int {
    let liveNeighbors = grid^.localSum()
    let live = (grid^)[grid^.focus]
    
    if live == 1 {
        return (liveNeighbors >= 2 && liveNeighbors <= 3) ? 1 : 0
    } else {
        return (liveNeighbors == 3) ? 1 : 0
    }
}
