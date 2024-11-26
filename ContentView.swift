import SwiftUI

struct ContentView: View {
    @AppStorage("counter1") private var counter1 = 0
    @AppStorage("counter2") private var counter2 = 0
    @AppStorage("counter3") private var counter3 = 0
    @State private var isSpinning = false
    
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
            
            HStack(spacing: 20) {
                // 老虎機按鈕
                Button(action: {
                    isSpinning = true
                    // 模擬老虎機效果，分三階段
                    // 第一階段：快速旋轉
                    for i in 1...30 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.05) {
                            counter1 = Int.random(in: 0...9)
                            counter2 = Int.random(in: 0...9)
                            counter3 = Int.random(in: 0...9)
                        }
                    }
                    
                    // 第二階段：減速
                    for i in 1...20 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 + Double(i) * 0.1) {
                            counter1 = Int.random(in: 0...9)
                            counter2 = Int.random(in: 0...9)
                            counter3 = Int.random(in: 0...9)
                        }
                    }
                    
                    // 第三階段：最終停止
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                        withAnimation(.easeOut(duration: 0.5)) {
                            counter1 = Int.random(in: 0...9)
                            counter2 = Int.random(in: 0...9)
                            counter3 = Int.random(in: 0...9)
                            isSpinning = false
                        }
                    }
                }) {
                    Text("🎰 轉動")
                        .font(.title)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isSpinning)
                
                // 清除按鈕
                Button(action: {
                    withAnimation {
                        counter1 = 0
                        counter2 = 0
                        counter3 = 0
                    }
                }) {
                    Text("🗑️ 清除")
                        .font(.title)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.top, 20)
        }
    }
}

struct CounterButton: View {
    @Binding var counter: Int
    var color: Color
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                self.counter = (self.counter + 1) % 10
            }
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
