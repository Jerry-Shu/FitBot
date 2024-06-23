import SwiftUI

struct ResponseView: View {
    var backendResponse: [String: Any]
    
    var body: some View {
        VStack {
            // Top Section
            HStack {
                Image(systemName: "return")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
                    .foregroundColor(.black)
                Spacer()
                Text("FitBot")
                    .font(.title)
                    .bold()
                    .padding(.trailing, 40)
                Spacer()
            }
            .padding(.vertical, 0) // Reduce vertical padding to make the bar thinner
            .padding(.horizontal, 10) // Adjust the horizontal padding as needed
            .background(Color.black)
            .foregroundColor(.white)
            
            // Content Section
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Feedback")
                        .font(.title)
                        .bold()
                        .padding(.top, 20)
                    
                    if let data = backendResponse["data"] as? [String: Any] {
                        if let overallEvaluation = data["overall_evaluation"] as? [String] {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Overall Evaluation:")
                                    .font(.headline)
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
