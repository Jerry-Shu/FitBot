import SwiftUI

struct ProgressRingView: View {
    var rating: Double
    var goal: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.3)
                .foregroundColor(Color.orange)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.rating / self.goal, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.orange)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            
            VStack {
                Image(systemName: "figure.strengthtraining.traditional")
                    .resizable()
                    .frame(width: 40, height: 40)
                Text(String(format: "%.0f / 100", min(self.rating / self.goal * 100, 100.0)))
                    .font(.title2)
                    .bold()
            }
            
            if rating <= 30 {
                Text("Needs Improvement: Consider focusing on core strength and form. Consistency is key.")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.orange)
                    .offset(x: 190)
            } else if rating <= 60 {
                Text("Good Effort: You're making progress. Keep working on your technique.")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.orange)
                    .offset(x: 190)
            } else if rating <= 80 {
                Text("Great Job: Your form and strength are improving. Keep up the good work!")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.orange)
                    .offset(x: 190)
            } else {
                Text("Excellent: You're doing fantastic! Maintain your routine and stay strong.")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.orange)
                    .offset(x: 160)
            }
        }
        .frame(width: 150, height: 150)
    }
}

struct ResponseView: View {
    var backendResponse: [String: Any]
    
    var body: some View {
        VStack {
            // Top Section
            HStack {
                Spacer()
                Text("FitBot")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding(.vertical, 5) // Reduce vertical padding to make the bar thinner
            .padding(.horizontal, 10) // Adjust the horizontal padding as needed
            .background(Color.black)
            .foregroundColor(.white)
            
            // Content Section
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Overall Rating")
                        .font(.title)
                        .bold()
                        .padding(.top, 20)
                        .foregroundColor(.orange)
                    
                    // Progress Ring View
                    if let data = backendResponse["data"] as? [String: Any],
                       let rating = data["rating"] as? Double {
                        HStack {
                            ProgressRingView(rating: rating, goal: 100)
                                .padding(.vertical, 20)
                        }
                    }
                    
                    if let data = backendResponse["data"] as? [String: Any] {
                        if let overallEvaluation = data["overall_evaluation"] as? [String] {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Overall Evaluation:")
                                    .font(.headline)
                                    .foregroundColor(.orange)
                                    .padding(.top, 10)
                                
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(height: 6)
                                
                                ForEach(overallEvaluation.indices, id: \.self) { index in
                                    HStack(alignment: .top) {
                                        Text("\(index + 1)")
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding(6)
                                            .background(Color.orange)
                                            .clipShape(Circle())
                                        Text(overallEvaluation[index])
                                            .padding(.leading, 5)
                                    }
                                    .padding(.top, 5)
                                }
                            }
                        }
                        
                        if let potentialImprovement = data["potential_improvement"] as? [[String: String]] {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Potential Improvements:")
                                    .font(.headline)
                                    .foregroundColor(.orange)
                                    .padding(.top, 10)
                                
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(height: 6)
                                
                                ForEach(potentialImprovement.indices, id: \.self) { index in
                                    if let problem = potentialImprovement[index]["problem"], let suggestion = potentialImprovement[index]["improvement"] {
                                        VStack(alignment: .leading) {
                                            HStack(alignment: .top) {
                                                Text("\(index + 1)")
                                                    .bold()
                                                    .foregroundColor(.white)
                                                    .padding(6)
                                                    .background(Color.orange)
                                                    .clipShape(Circle())
                                                VStack(alignment: .leading) {
                                                    Text("**Problem:** \(problem)")
                                                    Text("**Suggestion:** \(suggestion)")
                                                        .padding(.top, 2)
                                                }
                                                .padding(.leading, 5)
                                            }
                                            .padding(.top, 5)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct ResponseView_Previews: PreviewProvider {
    static var previews: some View {
        let mockResponse: [String: Any] = [
            "statusMessage": "Success",
            "data": [
                "rating": 72.0,
                "overall_evaluation": [
                    "The individual is attempting a deadlift with a specialized barbell",
                    "The stance appears to be too narrow for optimal deadlift form",
                    "The back position seems slightly rounded, which can be risky",
                    "Grip on the barbell looks appropriate",
                    "The lifter's attire is suitable for the exercise"
                ],
                "potential_improvement": [
                    [
                        "improvement": "Widen the stance to about shoulder-width apart for better stability and power generation",
                        "problem": "Narrow stance"
                    ],
                    [
                        "improvement": "Focus on maintaining a neutral spine throughout the lift by engaging the core and keeping the chest up",
                        "problem": "Rounded back"
                    ],
                    [
                        "improvement": "Ensure proper setup by hinging at the hips, keeping shins close to the bar, and tensioning the body before initiating the lift",
                        "problem": "Incomplete setup"
                    ],
                    [
                        "improvement": "Emphasize the hip hinge movement by pushing the hips back further before bending the knees to reach the bar",
                        "problem": "Unclear hip hinge"
                    ],
                    [
                        "improvement": "Double-check that both hands are evenly placed on the barbell for balanced lifting",
                        "problem": "Possible uneven grip"
                    ]
                ]
            ],
            "statusCode": 0
        ]
        ResponseView(backendResponse: mockResponse)
    }
}
