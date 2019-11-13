import SwiftUI

struct ContentView: View {
    @ObservedObject var store = Store(initialState: Pattern.glider.grid, reducer: conwayReducer)
    @State var isStarted = false
    @State var showPicker = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                grid
                Spacer()
                startStopButton
            }.navigationBarTitle("Conway's Game of Life")
        }.sheet(isPresented: $showPicker) {
            PatternPicker { pattern in
                self.store.send(.select(pattern))
            }
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
        HStack {
            Button("Select pattern") {
                self.showPicker = true
            }.disabled(isStarted)
            
            Spacer()
            
            if isStarted {
                Button("Stop") {
                    self.isStarted = false
                }
            } else {
                Button("Start") {
                    self.isStarted = true
                    self.simulateGame()
                }
            }
        }.padding()
    }
    
    func simulateGame() {
        if isStarted {
            store.send(.stepSimulation)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: simulateGame)
        }
    }
}

struct PatternPicker: View {
    @Environment(\.presentationMode) var presentation
    let select: (Pattern) -> Void
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Pattern.allCases, id: \.self) { pattern in
                    Button(pattern.title) {
                        self.select(pattern)
                        self.presentation.wrappedValue.dismiss()
                    }
                }
            }.navigationBarTitle("Select pattern")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
