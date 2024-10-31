import SwiftUI
import NaturalLanguage

struct ContentView: View {
    @State private var currentOutput = "Analyzing sentiment..."
    @State private var isPositive = true // To toggle between outputs
    
    var body: some View {
        VStack {
            Text(currentOutput) // Display the current output
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding()
                .onAppear {
                    Task {
                        await startSentimentAlternator()
                    }
                }
        }
    }
    
    // Asynchronous function to alternate the output every second
    private func startSentimentAlternator() async {
        let positiveText = "I love Swift programming!"
        let negativeText = "I am not a fan of bugs in code."
        
        // Pre-compute sentiment results
        let positiveSentiment = analyzeSentiment(for: positiveText)
        let negativeSentiment = analyzeSentiment(for: negativeText)
        
        while true {
            // Switch between positive and negative sentiments
            if isPositive {
                currentOutput = positiveSentiment == .positive ? "Positive sentiment detected! 😊" : "Negative sentiment detected. 😟"
            } else {
                currentOutput = negativeSentiment == .positive ? "Positive sentiment detected! 😊" : "Negative sentiment detected. 😟"
            }
            
            isPositive.toggle() // Toggle the sentiment for the next round
            try? await Task.sleep(nanoseconds: 666) // 1-second delay
        }
    }
    
    // Function to analyze sentiment using Natural Language framework
    private func analyzeSentiment(for text: String) -> SentimentType {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        
        let sentimentScore = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore).0
        let score = Double(sentimentScore?.rawValue ?? "0") ?? 0.0
        
        return score > 0 ? .positive : .negative
    }
}

// Enum for different types of sentiment
enum SentimentType {
    case positive
    case negative
}

#Preview {
    ContentView()
}
