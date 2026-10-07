import SwiftUI

/// Centralized user-facing strings.
///
/// Views should reference these keys instead of embedding display text. The
/// Japanese and English values live in `Resources/Localizable.xcstrings`.
enum AppStrings {
    enum Common {
        static let back: LocalizedStringKey = "common.back"
        static let next: LocalizedStringKey = "common.next"
        static let connect: LocalizedStringKey = "common.connect"
        static let skip: LocalizedStringKey = "common.skip"
        static let start: LocalizedStringKey = "common.start"
        static let settings: LocalizedStringKey = "common.settings"
        static let finish: LocalizedStringKey = "common.finish"
        static let continueRun: LocalizedStringKey = "common.continue"
        static let openSettings: LocalizedStringKey = "common.openSettings"
        static let kilometers: LocalizedStringKey = "common.kilometers"
        static let perKilometer: LocalizedStringKey = "common.perKilometer"
        static let kilocalories: LocalizedStringKey = "common.kilocalories"
        static let bpm: LocalizedStringKey = "common.bpm"
        static let distance: LocalizedStringKey = "common.distance"
        static let time: LocalizedStringKey = "common.time"
        static let date: LocalizedStringKey = "common.date"
        static let speed: LocalizedStringKey = "common.speed"
        static let noRecords: LocalizedStringKey = "common.noRecords"
        static let ellipsis: LocalizedStringKey = "common.ellipsis"
        static let swipeToUnlock: LocalizedStringKey = "common.swipeToUnlock"
        static let endRunTitle: LocalizedStringKey = "common.endRun.title"
    }

    enum Home {
        static let lastRun: LocalizedStringKey = "home.lastRun"
        static let latestStatus: LocalizedStringKey = "home.latestStatus"
        static let history: LocalizedStringKey = "home.history"
        static let arSettings: LocalizedStringKey = "home.arSettings"
        static let phoneSettings: LocalizedStringKey = "home.phoneSettings"
        static let runTogether: LocalizedStringKey = "home.runTogether"
        static let getStarted: LocalizedStringKey = "home.getStarted"
    }

    enum Location {
        static let permissionTitle: LocalizedStringKey = "location.permission.title"
        static let permissionMessage: LocalizedStringKey = "location.permission.message"
    }

    enum Onboarding {
        static let connectEyebrow: LocalizedStringKey = "onboarding.connect.eyebrow"
        static let connectTitle: LocalizedStringKey = "onboarding.connect.title"
        static let connectedStatus: LocalizedStringKey = "onboarding.connect.status.connected"
        static let scanningStatus: LocalizedStringKey = "onboarding.connect.status.scanning"
        static let searchingStatus: LocalizedStringKey = "onboarding.connect.status.searching"
        static let start: LocalizedStringKey = "onboarding.start"

        static let welcomeEyebrow: LocalizedStringKey = "onboarding.page.welcome.eyebrow"
        static let welcomeTitle: LocalizedStringKey = "onboarding.page.welcome.title"
        static let welcomeBody: LocalizedStringKey = "onboarding.page.welcome.body"
        static let avatarEyebrow: LocalizedStringKey = "onboarding.page.avatar.eyebrow"
        static let avatarTitle: LocalizedStringKey = "onboarding.page.avatar.title"
        static let avatarBody: LocalizedStringKey = "onboarding.page.avatar.body"
        static let syncEyebrow: LocalizedStringKey = "onboarding.page.sync.eyebrow"
        static let syncTitle: LocalizedStringKey = "onboarding.page.sync.title"
        static let syncBody: LocalizedStringKey = "onboarding.page.sync.body"
    }

    enum Devices {
        static let setupEyebrow: LocalizedStringKey = "devices.setup.eyebrow"
        static let title: LocalizedStringKey = "devices.title"
        static let subtitle: LocalizedStringKey = "devices.subtitle"
        static let arGlasses: LocalizedStringKey = "devices.arGlasses"
        static let xrealOne: LocalizedStringKey = "devices.xrealOne"
        static let appleWatch: LocalizedStringKey = "devices.appleWatch"
        static let seriesUltra: LocalizedStringKey = "devices.seriesUltra"
        static let airPods: LocalizedStringKey = "devices.airPods"
        static let proMax: LocalizedStringKey = "devices.proMax"
        static let tapToConnect: LocalizedStringKey = "devices.tapToConnect"
        static let connected: LocalizedStringKey = "devices.connected"
        static let connecting: LocalizedStringKey = "devices.connecting"
    }

    enum Settings {
        static let eyebrow: LocalizedStringKey = "settings.eyebrow"
        static let title: LocalizedStringKey = "settings.title"
        static let subtitle: LocalizedStringKey = "settings.subtitle"
        static let duration: LocalizedStringKey = "settings.duration"
        static let distance: LocalizedStringKey = "settings.distance"
        static let pace: LocalizedStringKey = "settings.pace"
    }

    enum Route {
        static let eyebrow: LocalizedStringKey = "route.eyebrow"
        static let title: LocalizedStringKey = "route.title"
        static let subtitle: LocalizedStringKey = "route.subtitle"
        static let pastRoutes: LocalizedStringKey = "route.pastRoutes"
        static let start: LocalizedStringKey = "route.start"
    }

    enum Course {
        static let origin: LocalizedStringKey = "course.origin"
        static let destination: LocalizedStringKey = "course.destination"
    }

    enum Running {
        static let active: LocalizedStringKey = "running.active"
        static let pace: LocalizedStringKey = "running.pace"
        static let syncRate: LocalizedStringKey = "running.syncRate"
    }

    enum History {
        static let activityEyebrow: LocalizedStringKey = "history.activity.eyebrow"
        static let niceRun: LocalizedStringKey = "history.niceRun"
        static let syncRate: LocalizedStringKey = "history.syncRate"
        static let targetAchieved: LocalizedStringKey = "history.targetAchieved"
        static let distance: LocalizedStringKey = "history.distance"
        static let duration: LocalizedStringKey = "history.duration"
        static let averagePace: LocalizedStringKey = "history.averagePace"
        static let calories: LocalizedStringKey = "history.calories"
        static let viewHistory: LocalizedStringKey = "history.viewHistory"
        static let eyebrow: LocalizedStringKey = "history.eyebrow"
        static let title: LocalizedStringKey = "history.title"
    }

    enum Formats {
        static func routeDistance(_ distance: Double) -> String {
            String.localizedStringWithFormat(String(localized: "format.route.distance"), distance)
        }

        static func runningDistance(_ distance: Double) -> String {
            String.localizedStringWithFormat(String(localized: "format.running.distance"), distance)
        }

        static func settingsDistance(_ distance: Double) -> String {
            String.localizedStringWithFormat(String(localized: "format.settings.distance"), distance)
        }

        static func settingsPace(_ pace: Double) -> String {
            String.localizedStringWithFormat(String(localized: "format.settings.pace"), pace)
        }
    }
}
