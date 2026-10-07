//
//  Phonesettingview.swift
//  AR_Runner_UI
//
//  Created by sym on 2026/10/05.
//
import SwiftUI

// MARK: - Phone Settings Screen
struct PhoneSettingsView: View {
    let onBack: () -> Void

    @State private var notificationsEnabled = true
    @State private var backgroundLocationEnabled = true
    @State private var distanceUnit = 0 // 0 = km, 1 = mile

    var body: some View {
        ARScreen {
            VStack(spacing: 0) {
                HStack {
                    ARBackButton(action: onBack)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 56)
                .padding(.bottom, 16)

                VStack(alignment: .leading, spacing: 4) {
                    ARLabel(text: "SETTINGS")
                    Text("スマホ設定")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                    Text("アプリの通知・位置情報・単位を設定します")
                        .font(.system(size: 14))
                        .foregroundColor(.arGrayText)
                        .padding(.top, 2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 28)
                .padding(.bottom, 24)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        toggleRow(icon: "bell.fill", title: "通知", isOn: $notificationsEnabled)
                        toggleRow(icon: "location.fill", title: "バックグラウンド位置情報", isOn: $backgroundLocationEnabled)

                        // Distance unit
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "ruler")
                                    .foregroundColor(.arYellow)
                                Text("距離の単位")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            Picker("", selection: $distanceUnit) {
                                Text("km").tag(0)
                                Text("mile").tag(1)
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding(16)
                        .background(Color.arCard)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.arBorder, lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 52)
                }
            }
        }
    }

    private func toggleRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.arYellow)
                .frame(width: 24)
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(.arYellow)
        }
        .padding(16)
        .background(Color.arCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.arBorder, lineWidth: 1)
        )
    }
}
