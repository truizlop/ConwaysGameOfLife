import SwiftUI

public final class Store<State, Action>: ObservableObject {
    @Published var state: State
    let reducer: (State, Action) -> State
    
    init(initialState: State, reducer: @escaping (State, Action) -> State) {
        self.state = initialState
        self.reducer = reducer
    }
    
    func send(_ action: Action) {
        state = reducer(state, action)
    }
}
