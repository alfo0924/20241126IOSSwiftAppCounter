import SwiftUI

struct ContentView: View {
    @State private var counter1 = 0
    @State private var counter2 = 0
    @State private var counter3 = 0
    
    var body: some View {
        VStack {
            CounterButton(counter: $counter1, color: .green)
            CounterButton(counter: $counter2, color: .blue)
            CounterButton(counter: $counter3, color: .red)
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
