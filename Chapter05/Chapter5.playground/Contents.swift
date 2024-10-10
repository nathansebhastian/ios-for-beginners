// if/else conditional
var balance = 4000

if (balance > 5000) {
    print("You have the money for this trip. Let's go!")
} else if (balance > 3000) {
    print("You only have enough money for a staycation")
} else {
    print("Sorry, not enough money. Save more!")
}
print("The end!")

// switch/case conditional
let weekdayNumber = 1

switch weekdayNumber {
  case 0:
    print("Sunday")
  case 1:
    print("Monday")
  case 2:
    print("Tuesday")
  case 3:
    print("Wednesday")
  case 4:
    print("Thursday")
  case 5:
    print("Friday")
  case 6:
    print("Saturday")
  default:
    print("The weekday number is invalid")
}

// for/in loop
var heads = 0
var tails = 0

for _ in 1...10 {
    if Int.random(in: 0...1 ) == 1 {
        heads += 1
    } else {
        tails += 1
    }
}

print("Tossed the coin ten times")
print("Number of heads: \(heads)")
print("Number of tails: \(tails)")

// while loop
var flips = 0
var isHeads = false

while isHeads == false {
    flips += 1
    isHeads = Int.random(in: 0...1) == 1
}

print("It took \(flips) flips to land on heads.")
