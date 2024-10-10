// Array
var numbers = [1, 2, 3]

// Change the values
numbers[0] = 10
numbers[1] = 20
numbers[2] = 30

// Tuple
var person = ("Nathan", 29)

print(person.0) // Nathan
print(person.1) // 29

// Set
var mySet: Set = ["John", "Doe"]

mySet.insert("Murray")
mySet.remove("Doe")

print(mySet)  // ["John", "Murray"]

// Dictionary
var myDictionary = ["firstName": "John", "lastName": "Doe"]

// change value in a specific key
myDictionary["firstName"] = "Lisa"

// add a new key-value pair to the dictionary
myDictionary["occupation"] = "Swift Engineer"

// delete a key-value pair from the dictionary
myDictionary.removeValue(forKey: "lastName")

print(myDictionary)
// ["occupation": "Swift Engineer", "firstName": "Lisa"]
