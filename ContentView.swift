import SwiftUI

struct ContentView: View {
    @AppStorage("counter1") private var counter1 = 0
    @AppStorage("counter2") private var counter2 = 0
    @AppStorage("counter3") private var counter3 = 0
    
    var body: some View {
        VStack {
            CounterButton(counter: Binding(
                get: { counter1 },
                set: { counter1 = $0 }
            ), color: .green)
            
            CounterButton(counter: Binding(
                get: { counter2 },
                set: { counter2 = $0 }
            ), color: .blue)
            
            CounterButton(counter: Binding(
                get: { counter3 },
                set: { counter3 = $0 }
            ), color: .red)
        }
    }
}

struct CounterButton: View {
    @Binding var counter: Int
    var color: Color
    
    var body: some View {
        Button(action: {
            self.counter += 1
        }) {
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(color)
                .overlay(
                    Text("\(counter)")
                        .font(.system(size: 100, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
