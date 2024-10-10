// Enumeration
enum Direction {
    case north, south, east, west
}

// Protocol
protocol Car {
    var maker: String  {get set}
    var wheels: Int {get}
    
    func drive()
}

// Appling Protocol example:
protocol Addition {
    func addition() -> Int
}

protocol Subtraction {
    func subtraction() -> Int
}

class Calculate: Addition, Subtraction {
    var a: Int
    var b: Int
    
    init(a: Int, b: Int) {
        self.a = a
        self.b = b
    }
    
    func addition() -> Int {
        return a + b
    }
    
    func subtraction() -> Int {
        return a - b
    }
}

// Extension
struct Vehicle {
    var vehicleType: String
    var maker: String
}

extension Vehicle {
    func start() {
        print("Starting the engine...")
        print("Engine started")
    }
}
