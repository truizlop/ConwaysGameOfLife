import SwiftUI

struct ContentView: View {
    @ObservedObject var store = Store(initialState: Pattern.glider.grid, reducer: conwayReducer)
    @State var isStarted = false
    
    var body: some View {
        NavigationView {
            grid.navigationBarTitle("Conway's Game of Life")
                .navigationBarItems(trailing: self.startStopButton)
        }
    }
    
    var grid: some View {
        VStack {
            ForEach(store.state, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { cell in
                        Text(cell.description)
                            .font(.title)
                    }
                }
            }
        }
    }
    
    var startStopButton: some View {
        if isStarted {
            return Button("Stop") {
                self.isStarted = false
            }
        } else {
            return Button("Start") {
                self.isStarted = true
                self.simulateGame()
            }
        }
    }
    
    func simulateGame() {
        if isStarted {
            store.send(.stepSimulation)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: simulateGame)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
