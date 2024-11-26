import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    let isDarkMode: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 30)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
            )
            .foregroundColor(isDarkMode ? .white : .black)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2), value: configuration.isPressed)
    }
}

struct NumberBoxView: View {
    let number: Int
    let isDarkMode: Bool
    let action: () -> Void
    @State private var rotation: Double = 0
    
    var body: some View {
        Text("\(number)")
            .font(.system(size: 48, weight: .medium, design: .rounded))
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
            )
            .foregroundColor(isDarkMode ? .white : .black)
            .rotation3DEffect(
                .degrees(rotation),
                axis: (x: 0, y: 1, z: 0)
            )
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    rotation += 360
                }
                action()
            }
    }
}

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("number1") private var number1 = 0
    @AppStorage("number2") private var number2 = 0
    @AppStorage("number3") private var number3 = 0
    @State private var isSpinning = false
    
    var numbers: [Int] {
        get { [number1, number2, number3] }
        set {
            number1 = newValue[0]
            number2 = newValue[1]
            number3 = newValue[2]
        }
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Text("數字遊戲")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(isDarkMode ? .white : .black)
                .padding(.top, 40)
            
            HStack(spacing: 20) {
                ForEach(0..<3) { index in
                    NumberBoxView(number: numbers[index], isDarkMode: isDarkMode) {
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
                }
            }
            .padding(.vertical, 30)
            
            VStack(spacing: 16) {
                Button("隨機生成") {
                    spinNumbers()
                }
                .buttonStyle(CustomButtonStyle(isDarkMode: isDarkMode))
                
                Button("清除") {
                    withAnimation(.spring(response: 0.3)) {
                        number1 = 0
                        number2 = 0
                        number3 = 0
                    }
                }
                .buttonStyle(CustomButtonStyle(isDarkMode: isDarkMode))
                
                Button(isDarkMode ? "切換淺色模式" : "切換深色模式") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isDarkMode.toggle()
                    }
                }
                .buttonStyle(CustomButtonStyle(isDarkMode: isDarkMode))
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isDarkMode ? Color.black : Color.white)
        .animation(.easeInOut, value: isDarkMode)
    }
    
    private func spinNumbers() {
        isSpinning = true
        var counter = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            withAnimation(.spring(response: 0.3)) {
                number1 = Int.random(in: 0...9)
                number2 = Int.random(in: 0...9)
                number3 = Int.random(in: 0...9)
            }
            counter += 1
            if counter >= 10 {
                timer.invalidate()
                isSpinning = false
            }
        }
    }
}

#Preview {
    ContentView()
}
