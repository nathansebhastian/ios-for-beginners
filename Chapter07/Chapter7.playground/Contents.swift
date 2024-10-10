// Function
func greet(name: String = "Nathan", weather: String? = nil) {
    print("Hello, \(name)")
    if weather != nil {
        print("It's \(weather!) today, right?")
    }
}

// Return statement
func checkAge(age: Int) -> String {
  if age > 18 {
    return "You may get a car license"
  }
  return "You can not get a car license yet"
}

print(checkAge(age: 20))
print(checkAge(age: 15))

// Function with variadic parameter
func sumNumbers(args: Int...) {
    var sum = args.reduce(0, +)
    print(sum)
}

sumNumbers(args: 1, 2)  // 3
sumNumbers(args: 1, 2, 3, 4)  // 10
sumNumbers(args: 10, 10, 10, 10, 10, 10)  // 60

// guard/else statement
func submit() {
    var username = ""
    guard !username.isEmpty else {
        print("Username cannot be empty")
        return
    }
    
    print("Username validated")
    print("Sending data for processing...")
}

submit()

// Closure
var myNumbers = [10, 6, 9, 2, 3]

var sortedNumbers = myNumbers.sorted { $0 < $1 }

print(sortedNumbers) // [2, 3, 6, 9, 10]
