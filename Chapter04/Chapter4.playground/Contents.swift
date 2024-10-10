// This playground only show types. You can use them to test operators.

// Strings
var myName = "Nathan"

var greeting = "Hello, \(myName)!" // "Hello, Nathan!"

var myScore = 8

var message = "Your score is \(myScore)" // "Your score is 8"

// numbers
var myNumber = 5

var floatingNumber = 5.001

// booleans
var isCompleted = true

isCompleted = false

// Type annotation
var greetings: String  // Variable has no initial value

greetings = "Hello!" // Value assigned after declaration

var number = 4 // Swift will infer the type as Int

var anotherNumber: Double = 4 // Force the variable to be Double

// Any type
var username: Any = "Nathan"

username = 5

// Optional type
var secretString: String?

print(secretString ?? "Hello, world!")
