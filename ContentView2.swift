import SwiftUI

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("number1") private var number1 = 0
    @AppStorage("number2") private var number2 = 0
    @AppStorage("number3") private var number3 = 0
    
    var numbers: [Int] {
        get { [number1, number2, number3] }
        set {
            number1 = newValue[0]
            number2 = newValue[1]
            number3 = newValue[2]
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            HStack(spacing: 20) {
                ForEach(0..<3) { index in
                    Text("\(numbers[index])")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(isDarkMode ? .white : .black)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                let newValue = (numbers[index] + 1) % 10
                                switch index {
                                case 0: number1 = newValue
                                case 1: number2 = newValue
                                case 2: number3 = newValue
                                default: break
                                }
                            }
                        }
                        .scaleEffect(1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: numbers[index])
                }
            }
            .padding()
            
            Button("隨機生成") {
                withAnimation {
                    number1 = Int.random(in: 0...9)
                    number2 = Int.random(in: 0...9)
                    number3 = Int.random(in: 0...9)
                }
            }
            
            Button("清除") {
                withAnimation {
                    number1 = 0
                    number2 = 0
                    number3 = 0
                }
            }
            
            Button(isDarkMode ? "淺色模式" : "深色模式") {
                withAnimation {
                    isDarkMode.toggle()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isDarkMode ? Color.black : Color.white)
    }
}

#Preview {
    ContentView()
}
