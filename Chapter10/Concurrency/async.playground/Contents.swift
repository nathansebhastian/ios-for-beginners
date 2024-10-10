import Foundation

// Async function to fetch weather data
func fetchUser() async -> String {
    print("Fetching user data...")
    
    sleep(3) // 3 seconds
    
    print("User fetched")
    return "Name: Nathan"
}

// Async function to fetch news headlines
func fetchNews() async -> String {
    print("Fetching the latest news...")
    
    sleep(2) // 2 seconds
 
    print("News fetched")
    return "iOS 18 is here!"
}

func main() async {
    let userTask = Task { await fetchUser() }
    let newsTask = Task { await fetchNews() }

    let userResult = await userTask.value
    let newsResult = await newsTask.value

    // Process and print results
    print("User: \(userResult)")
    print("News: \(newsResult)")
}

Task {
    await main()
}
