import Bow

public final class ForFocusedGrid {}
public typealias FocusedGridOf<A> = Kind<ForFocusedGrid, A>

public final class FocusedGrid<A>: FocusedGridOf<A> {
    let focus: (x: Int, y: Int)
    let grid: [[A]]
    
    public static func fix(_ value: FocusedGridOf<A>) -> FocusedGrid<A> {
        value as! FocusedGrid<A>
    }
    
    public init(focus: (x: Int, y: Int), grid: [[A]]) {
        self.focus = focus
        self.grid = grid
    }
    
    public subscript(at: (Int, Int)) -> A {
        self[at.0, at.1]
    }
    
    public subscript(x: Int, y: Int) -> A {
        let x = (x + grid.count) % grid.count
        let y = (y + grid[x].count) % grid[x].count
        return grid[x][y]
    }
}

public postfix func ^<A>(_ value: FocusedGridOf<A>) -> FocusedGrid<A> {
    FocusedGrid.fix(value)
}

extension ForFocusedGrid: Functor {
    public static func map<A, B>(_ fa: Kind<ForFocusedGrid, A>, _ f: @escaping (A) -> B) -> Kind<ForFocusedGrid, B> {
        FocusedGrid(focus: fa^.focus,
                    grid: fa^.grid.map { row in row.map(f) })
    }
}

extension ForFocusedGrid: Comonad {
    public static func coflatMap<A, B>(_ fa: Kind<ForFocusedGrid, A>, _ f: @escaping (Kind<ForFocusedGrid, A>) -> B) -> Kind<ForFocusedGrid, B> {
        FocusedGrid(focus: fa^.focus, grid: fa^.grid.enumerated().map { x in
            x.element.enumerated().map { y in
                f(FocusedGrid(focus: (x.offset, y.offset),
                              grid: fa^.grid))
            }
        })
    }
    
    public static func extract<A>(_ fa: Kind<ForFocusedGrid, A>) -> A {
        (fa^)[fa^.focus]
    }
}

extension ForFocusedGrid: EquatableK {
    public static func eq<A: Equatable>(_ lhs: Kind<ForFocusedGrid, A>, _ rhs: Kind<ForFocusedGrid, A>) -> Bool {
        lhs^.grid == rhs^.grid
    }
}
