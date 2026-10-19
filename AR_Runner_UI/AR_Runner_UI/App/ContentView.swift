import SwiftUI

// MARK: - Navigation State

struct ContentView: View {
    private static let onboardingCompletionKey = "hasCompletedOnboarding"
    @State private var screen: AppScreen
    @State private var runConfiguration = RunConfiguration()

    init() {
        let onboardingDone = UserDefaults.standard.bool(forKey: Self.onboardingCompletionKey)
        let initialScreen: AppScreen
        if !onboardingDone {
            initialScreen = .onboarding
        } else if !BodyInfoStore.shared.hasCompletedInitialSetup {
            initialScreen = .bodyInfo
        } else {
            initialScreen = .home   // was .deviceConnect
        }
        _screen = State(initialValue: initialScreen)
    }

    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: Self.onboardingCompletionKey)
        screen = .home
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            switch screen {

            // 1. Three-page tutorial
            case .onboarding:
                OnboardingView(
                    onNext: { screen = BodyInfoStore.shared.hasCompletedInitialSetup ? .home : .bodyInfo },
                    onBack: { }
                )

            // add on
            case .home:
                HomeView(
                    onNext: { screen = .deviceConnect },
                    onBack: { },
                    onOpenHistory: { screen = .history },
                    onOpenARSettings: { screen = .glassSettings },
                    onOpenPhoneSettings: { screen = .phoneSettings }
                )

            // 2. Connect AR glasses + Apple Watch + AirPods
            case .deviceConnect:
                DeviceConnectView(
                    onNext: { screen = .runningSettings },
                    onBack: { screen = .home }
                )

            // 3. Set time, distance, pace
            case .runningSettings:
                RunningSettingsView(
                    configuration: $runConfiguration,
                    onNext: { screen = .mapRoute },
                    onBack: { screen = .deviceConnect }
                )

            // 4. Draw route on map
            case .mapRoute:
                MapRouteView(
                    onNext: { screen = .lockScreen },
                    onBack: { screen = .deviceConnect }
                    // pastRoutes: defaults to [] until real route history data exists
                )

            // 4. Live running screen (HUD: elapsed time, distance, bpm, pace, sync rate)
            case .courseRunning:
                RunningView(
                    configuration: runConfiguration,
                    onEnd: { screen = .stats }
                )

            // 7. Stats
            case .stats:
                StatsView(
                    onHistory: { screen = .history },
                    onBack: { screen = .lockScreen },   // 戻る → lock screen
                    onFinish: { screen = .home }        // 終了 → home
                )

            // 8. History
            case .history:
                HistoryView(
                    onBack: { screen = .home }
                )

            case .lockScreen:
                LockScreenView(
                    onEnd: { screen = .stats }
                )
                
            // 9. AR Settings (from HomeView's hamburger menu)
            case .glassSettings:
                ARSettingsView(
                    onBack: { screen = .home }
                )
                
            // 10. Phone Settings (from HomeView's hamburger menu)
            case .phoneSettings:
                PhoneSettingsView(
                    onBack: { screen = .home },
                    onEditBodyInfo: { screen = .bodyInfoEdit },
                    onShowTutorial: { screen = .onboarding }
                )
                
            case .bodyInfo:
                BodyInfoView(
                    isInitialSetup: true,
                    onNext: { screen = .home },
                    onBack: { }
                )

            case .bodyInfoEdit:
                BodyInfoView(
                    isInitialSetup: false,
                    onNext: { screen = .phoneSettings },
                    onBack: { screen = .phoneSettings }
                )
            }
        }
        .animation(.easeInOut(duration: 0.3), value: screen)
    }
}
