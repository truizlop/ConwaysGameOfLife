import Bow
import BowLaws
import BowGenerators
import SwiftCheck
import XCTest
import ConwayGameOfLife

extension ForFocusedGrid: ArbitraryK {
    public static func generate<A: Arbitrary>() -> Kind<ForFocusedGrid, A> {
        let rows = Int.arbitrary.suchThat { x in x > 0 }.generate
        let columns = Int.arbitrary.suchThat { x in x > 0 }.generate
        let grid = (0 ..< rows).map { _ in
            (0 ..< columns).map { _ in
                A.arbitrary.generate
            }
        }
        let x = Int.arbitrary.suchThat { x in x >= 0 && x < rows }.generate
        let y = Int.arbitrary.suchThat { y in y >= 0 && y < columns }.generate
        return FocusedGrid(focus: (x, y), grid: grid)
    }
}

class FocusedGridTests: XCTestCase {
    func testEquatableKLaws() {
        EquatableKLaws<ForFocusedGrid, Int>.check()
    }
    
    func testFunctorLaws() {
        FunctorLaws<ForFocusedGrid>.check()
    }
    
    func testComonadLaws() {
        ComonadLaws<ForFocusedGrid>.check()
    }
}
