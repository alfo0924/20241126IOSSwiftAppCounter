import UIKit

struct People {
    var age: Int = 0 {
        willSet {
            print("will set new value \(newValue) as the new age.")
        }
    }
    func toString() -> String {
        return "Age: \(age)"
    }
}

var me = People()

me.age = 10
print(me.toString())

me.age = 11

