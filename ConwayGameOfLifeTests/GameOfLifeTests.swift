import SwiftCheck
import XCTest
@testable import ConwayGameOfLife

class GameOfLifeTests: XCTestCase {
    
    func testGameOfLifeRules() {
        property("An alive cell with 2 or three alive neighbors remains alive") <- forAll(aliveWith2or3AliveNeighbors()) { grid in
            conwayStep(grid) == 1
        }
        
        property("An alive cell with other number of alive neighbors will die") <- forAll(aliveWithOtherAliveNeighbors()) { grid in
            conwayStep(grid) == 0
        }
        
        property("A dead cell with exactly 3 alive neighbors comes back to life") <- forAll(deadWith3AliveNeighbors()) { grid in
            conwayStep(grid) == 1
        }
        
        property("A dead cell with other number of neighbors remains dead") <- forAll(deadWithOtherNumberOfAliveNeighbors()) { grid in
            conwayStep(grid) == 0
        }
    }
}

func aliveWith2or3AliveNeighbors() -> Gen<FocusedGrid<Int>> {
    Gen.one(of: [alive(withAliveNeighbors: 2),
                 alive(withAliveNeighbors: 3)])
}

func aliveWithOtherAliveNeighbors() -> Gen<FocusedGrid<Int>> {
    Gen.one(of: [0, 1, 4, 5, 6, 7, 8].map { n in alive(withAliveNeighbors: n) })
}

func deadWith3AliveNeighbors() -> Gen<FocusedGrid<Int>> {
    dead(withAliveNeighbors: 3)
}

func deadWithOtherNumberOfAliveNeighbors() -> Gen<FocusedGrid<Int>> {
    Gen.one(of: [0, 1, 2, 4, 5, 6, 7, 8].map { n in dead(withAliveNeighbors: n) } )
}

func alive(withAliveNeighbors n: Int) -> Gen<FocusedGrid<Int>> {
    grid(center: 1, withAliveNeighbors: n)
}

func dead(withAliveNeighbors n: Int) -> Gen<FocusedGrid<Int>> {
    grid(center: 0, withAliveNeighbors: n)
}

func grid(center: Int, withAliveNeighbors n: Int) -> Gen<FocusedGrid<Int>> {
    let alive = Array(repeating: 1, count: n)
    let dead = Array(repeating: 0, count: 8 - n)
    let all = alive + dead
    
    return Gen.pure(()).map { all.shuffled() }
        .map { array in
            FocusedGrid(focus: (1, 1),
                        grid: toGrid(center: center, neighbors: array)) }
}

func toGrid(center: Int, neighbors x: [Int]) -> [[Int]] {
    [
        [x[0], x[1], x[2]],
        [x[3], center, x[4]],
        [x[5], x[6], x[7]]
    ]
}
