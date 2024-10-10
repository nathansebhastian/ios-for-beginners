import SwiftUI
import StarRatingViewSwiftUI

struct ContentView: View {
    @State var score: Float = 0
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            StarRatingView(rating: $score)
                .frame(width: 100, height: 30)
        }
    }
}
