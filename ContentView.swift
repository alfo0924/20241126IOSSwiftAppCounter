import SwiftUI

// 主要內容視圖
struct ContentView: View {
    // 使用 @AppStorage 來持久化存儲三個計數器的值
    // 當 App 重新啟動時，數值會自動從 UserDefaults 中讀取
    @AppStorage("counter1") private var counter1 = 0
    @AppStorage("counter2") private var counter2 = 0
    @AppStorage("counter3") private var counter3 = 0
    
    var body: some View {
        // 垂直堆疊排列三個按鈕
        VStack {
            // 綠色計數器按鈕
            // 使用自定義 Binding 將 AppStorage 的值綁定到按鈕
            CounterButton(counter: Binding(
                get: { counter1 },
                set: { counter1 = $0 }
            ), color: .green)
            
            // 藍色計數器按鈕
            CounterButton(counter: Binding(
                get: { counter2 },
                set: { counter2 = $0 }
            ), color: .blue)
            
            // 紅色計數器按鈕
            CounterButton(counter: Binding(
                get: { counter3 },
                set: { counter3 = $0 }
            ), color: .red)
        }
    }
}

// 自定義計數器按鈕視圖
struct CounterButton: View {
    // 使用 Binding 來接收外部傳入的計數值
    @Binding var counter: Int
    // 按鈕顏色屬性
    var color: Color
    
    var body: some View {
        // 創建可點擊的按鈕
        Button(action: {
            // 點擊時計數加1
            self.counter += 1
        }) {
            // 繪製圓形按鈕
            Circle()
                // 設定圓形大小
                .frame(width: 200, height: 200)
                // 設定圓形顏色
                .foregroundColor(color)
                // 在圓形上方疊加文字
                .overlay(
                    // 顯示計數值
                    Text("\(counter)")
                        // 設定文字樣式：大小100、粗體、圓角字體
                        .font(.system(size: 100, weight: .bold, design: .rounded))
                        // 設定文字顏色為白色
                        .foregroundColor(.white)
                )
        }
    }
}

// 預覽提供者，用於在 Xcode 預覽畫面中查看視圖
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
