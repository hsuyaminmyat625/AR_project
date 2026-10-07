import SwiftUI

// MARK: - Device Connect Screen (All devices on one screen)
struct DeviceConnectView: View {
    let onNext: () -> Void
    let onBack: () -> Void

    @State private var arConnected = false
    @State private var watchConnected = false
    @State private var airPodsConnected = false
    @State private var arScanning = false
    @State private var watchScanning = false
    @State private var airPodsScanning = false
    @State private var pulse = false

    var allConnected: Bool { arConnected && watchConnected && airPodsConnected }

    var body: some View {
        ARScreen {
            VStack(spacing: 0) {
                // Nav bar
                HStack {
                    ARBackButton(action: onBack)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 56)
                .padding(.bottom, 20)

                // Header
                VStack(alignment: .leading, spacing: 4) {
                    ARLabel(text: AppStrings.Devices.setupEyebrow)
                    Text(AppStrings.Devices.title)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                    Text(AppStrings.Devices.subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.arGrayText)
                        .padding(.top, 2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 28)
                .padding(.bottom, 28)

                // Device cards
                VStack(spacing: 12) {
                    DeviceConnectRow(
                        icon: "eyeglasses",
                        name: AppStrings.Devices.arGlasses,
                        subtitle: AppStrings.Devices.xrealOne,
                        isConnected: $arConnected,
                        isScanning: $arScanning,
                        onConnect: {
                            arScanning = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                arScanning = false
                                arConnected = true
                            }
                        }
                    )
                    DeviceConnectRow(
                        icon: "applewatch",
                        name: AppStrings.Devices.appleWatch,
                        subtitle: AppStrings.Devices.seriesUltra,
                        isConnected: $watchConnected,
                        isScanning: $watchScanning,
                        onConnect: {
                            watchScanning = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                watchScanning = false
                                watchConnected = true
                            }
                        }
                    )
                    DeviceConnectRow(
                        icon: "airpodspro",
                        name: AppStrings.Devices.airPods,
                        subtitle: AppStrings.Devices.proMax,
                        isConnected: $airPodsConnected,
                        isScanning: $airPodsScanning,
                        onConnect: {
                            airPodsScanning = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                airPodsScanning = false
                                airPodsConnected = true
                            }
                        }
                    )
                }
                .padding(.horizontal, 24)

                Spacer()

                // Status hint
                if !allConnected {
                    Text(AppStrings.Devices.tapToConnect)
                        .font(.system(size: 13))
                        .foregroundColor(.arGrayText)
                        .padding(.bottom, 16)
                }

                // Next button — always available (user can skip devices)
                Button(action: onNext) {
                    ZStack {
                        Circle()
                            .fill(Color.arYellow)
                            .frame(width: 64, height: 64)
                            .shadow(color: Color.arYellow.opacity(allConnected ? 0.55 : 0.25), radius: 20)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, 52)
            }
        }
    }
}

// MARK: - Device Connect Row
struct DeviceConnectRow: View {
    let icon: String
    let name: LocalizedStringKey
    let subtitle: LocalizedStringKey
    @Binding var isConnected: Bool
    @Binding var isScanning: Bool
    let onConnect: () -> Void

    var body: some View {
        Button(action: {
            if !isConnected && !isScanning { onConnect() }
        }) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.arBG)
                        .frame(width: 56, height: 56)
                        .overlay(
                            Circle().stroke(
                                isConnected ? Color.arYellow.opacity(0.6) : Color.arBorder,
                                lineWidth: 1
                            )
                        )
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(isConnected ? .arYellow : .arGrayText)
                }

                // Text
                VStack(alignment: .leading, spacing: 3) {
                    Text(name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    HStack(spacing: 5) {
                        if isConnected {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.arYellow)
                            Text(AppStrings.Devices.connected)
                                .font(.system(size: 13))
                                .foregroundColor(.arYellow)
                        } else if isScanning {
                            ProgressView()
                                .scaleEffect(0.7)
                                .tint(Color.arGrayText)
                            Text(AppStrings.Devices.connecting)
                                .font(.system(size: 13))
                                .foregroundColor(.arGrayText)
                        } else {
                            Text(subtitle)
                                .font(.system(size: 13))
                                .foregroundColor(.arGrayText)
                        }
                    }
                }

                Spacer()

                // Status badge
                if isConnected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 28, height: 28)
                        .background(Color.arYellow)
                        .clipShape(Circle())
                } else {
                    Text(isScanning ? AppStrings.Common.ellipsis : AppStrings.Common.connect)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(isScanning ? .arGrayText : .arYellow)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.arYellow.opacity(isScanning ? 0.05 : 0.12))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.arYellow.opacity(isScanning ? 0.2 : 0.4), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(Color.arCard)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isConnected ? Color.arYellow.opacity(0.35) : Color.arBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isConnected)
        .animation(.easeInOut(duration: 0.2), value: isScanning)
    }
}
