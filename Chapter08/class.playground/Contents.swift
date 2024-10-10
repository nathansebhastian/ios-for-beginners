// Classes

class Vehicle {
    var vehicleType: String
    var maker: String
    
    init(vehicleType: String, maker: String){
        self.vehicleType = vehicleType
        self.maker = maker
    }
    
    func start(){
        print("Starting the engine..")
        print("\(vehicleType) is on")
    }
    
    func drive(speed: Int){
        print("Driving \(maker) at \(speed) mph")
    }
}

// Create Subclass / Child class
class Car: Vehicle {
    var transmission: String
    var wheels: Int
    
    init(vehicleType: String, maker: String, transmission: String, wheels: Int) {
        self.transmission = transmission
        self.wheels = wheels
        super.init(vehicleType: vehicleType, maker: maker)
    }
    
    func getCarDetails() {
        print("Transmission: \(transmission)")
        print("Number of wheels: \(wheels)")
    }
}
