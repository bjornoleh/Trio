import ActivityKit
import Foundation

struct LiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        let bg: String
        let direction: String?
        let change: String
        let date: Date

        let detailedViewState: ContentAdditionalState?

        /// true for the first state that is set on the activity
        let isInitialState: Bool
    }

    public struct ContentAdditionalState: Codable, Hashable {
        let chart: [Double]
        let chartDate: [Date?]
        let rotationDegrees: Double
        let highGlucose: Double
        let lowGlucose: Double
        let cob: Decimal
        let iob: Decimal
    }

    let startDate: Date
}
