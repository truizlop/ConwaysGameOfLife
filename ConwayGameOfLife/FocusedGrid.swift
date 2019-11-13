import Bow

public final class ForFocusedGrid {}
public typealias FocusedGridOf<A> = Kind<ForFocusedGrid, A>

public final class FocusedGrid<A>: FocusedGridOf<A> {
    let focus: (x: Int, y: Int)
    let grid: [[A]]
    
    static func fix(_ value: FocusedGridOf<A>) -> FocusedGrid<A> {
        value as! FocusedGrid<A>
    }
    
    init(focus: (x: Int, y: Int), grid: [[A]]) {
        self.focus = focus
        self.grid = grid
    }
    
    subscript(at: (Int, Int)) -> A {
        self[at.0, at.1]
    }
    
    subscript(x: Int, y: Int) -> A {
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
        let grid = fa^.grid.enumerated().map { x in
            x.element.enumerated().map { y in
                FocusedGrid(focus: (x.offset, y.offset),
                            grid: fa^.grid)
            }
        }
        return FocusedGrid(focus: fa^.focus, grid: grid).map(f)
    }
    
    public static func extract<A>(_ fa: Kind<ForFocusedGrid, A>) -> A {
        (fa^)[fa^.focus]
    }
}
