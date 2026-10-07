import SwiftUI

struct ContentView: View {
    private static let onboardingCompletionKey = "hasCompletedOnboarding"
    @State private var screen: AppScreen
    @State private var runConfiguration = RunConfiguration()

    init() {
        _screen = State(
            initialValue: UserDefaults.standard.bool(forKey: Self.onboardingCompletionKey)
            ? .home
            : .onboarding
        )
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
                    onNext: completeOnboarding,
                    onBack: { }
                )

            // add on
            case .home:
                HomeView(
                    onNext: { screen = .deviceConnect },
                    onBack: { }
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
                    onUnlock: { screen = .courseRunning },
                    onEnd: { screen = .stats }
                )
            }
        }
        .animation(.easeInOut(duration: 0.3), value: screen)
    }
}
