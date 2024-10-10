import Foundation

// A function to fetch weather data
func fetchUser() -> String {
    print("Fetching user data...")
    
    sleep(3) // 3 seconds
    
    print("User fetched")
    return "Name: Nathan"
}

// A function to fetch news headlines
func fetchNews() -> String {
    print("Fetching the latest news...")
    
    sleep(2) // 2 seconds
 
    print("News fetched")
    return "iOS 18 is here!"
}

// Process and print results
let userResult = fetchUser()
let newsResult = fetchNews()

print("User: \(userResult)")
print("News: \(newsResult)")
