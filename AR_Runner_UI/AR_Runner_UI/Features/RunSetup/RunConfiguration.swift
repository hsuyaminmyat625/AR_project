import Foundation

/// The user's goals for one running session.
/// This value is shared between the settings screen and the running screen.
struct RunConfiguration: Equatable {
    var durationSeconds: Int = 3600
    var distanceKm: Double = 10.0
    var paceKmh: Double = 8.0
}
