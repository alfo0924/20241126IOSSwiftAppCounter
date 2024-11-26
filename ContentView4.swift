import SwiftUI

// 自定義按鈕樣式
struct CustomButtonStyle: ButtonStyle {
    let isDarkMode: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 30)
            .padding(.vertical, 12)
            // 設定按鈕背景為圓角矩形
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
            )
            // 根據深淺色模式設定文字顏色
            .foregroundColor(isDarkMode ? .white : .black)
            // 按下時的縮放動畫效果
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2), value: configuration.isPressed)
    }
}

// 數字方塊視圖元件
struct NumberBoxView: View {
    let number: Int
    let isDarkMode: Bool
    let action: () -> Void
    // 控制旋轉動畫的狀態
    @State private var rotation: Double = 0
    
    var body: some View {
        Text("\(number)")
            // 設定數字字體樣式
            .font(.system(size: 48, weight: .medium, design: .rounded))
            .frame(width: 80, height: 80)
            // 設定背景樣式
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
            )
            .foregroundColor(isDarkMode ? .white : .black)
            // 3D旋轉效果
            .rotation3DEffect(
                .degrees(rotation),
                axis: (x: 0, y: 1, z: 0)
            )
            // 點擊觸發旋轉動畫
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    rotation += 360
                }
                action()
            }
    }
}

// 主要內容視圖
struct ContentView: View {
    // 使用 AppStorage 儲存設定，確保資料持久化
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("number1") private var number1 = 0
    @AppStorage("number2") private var number2 = 0
    @AppStorage("number3") private var number3 = 0
    // 控制數字旋轉動畫狀態
    @State private var isSpinning = false
    
    // 數字陣列的計算屬性
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
            // 標題
            Text("數字遊戲")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(isDarkMode ? .white : .black)
                .padding(.top, 40)
            
            // 數字方塊區域
            HStack(spacing: 20) {
                ForEach(0..<3) { index in
                    NumberBoxView(number: numbers[index], isDarkMode: isDarkMode) {
                        // 點擊數字時的動畫效果
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            let newValue = (numbers[index] + 1) % 10
                            // 更新對應的數字
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
            
            // 按鈕區域
            VStack(spacing: 16) {
                // 隨機生成按鈕
                Button("隨機生成") {
                    spinNumbers()
                }
                .buttonStyle(CustomButtonStyle(isDarkMode: isDarkMode))
                
                // 清除按鈕
                Button("清除") {
                    withAnimation(.spring(response: 0.3)) {
                        number1 = 0
                        number2 = 0
                        number3 = 0
                    }
                }
                .buttonStyle(CustomButtonStyle(isDarkMode: isDarkMode))
                
                // 深淺色模式切換按鈕
                Button(isDarkMode ? "切換淺色模式" : "切換深色模式") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isDarkMode.toggle()
                    }
                }
                .buttonStyle(CustomButtonStyle(isDarkMode: isDarkMode))
            }
            
            Spacer()
        }
        // 設定整體框架和背景
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isDarkMode ? Color.black : Color.white)
        .animation(.easeInOut, value: isDarkMode)
    }
    
    // 隨機生成數字的函數
    private func spinNumbers() {
        isSpinning = true
        var counter = 0
        // 設定計時器，產生連續變化效果
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            withAnimation(.spring(response: 0.3)) {
                number1 = Int.random(in: 0...9)
                number2 = Int.random(in: 0...9)
                number3 = Int.random(in: 0...9)
            }
            counter += 1
            // 執行10次後停止
            if counter >= 10 {
                timer.invalidate()
                isSpinning = false
            }
        }
    }
}

// 預覽
#Preview {
    ContentView()
}
