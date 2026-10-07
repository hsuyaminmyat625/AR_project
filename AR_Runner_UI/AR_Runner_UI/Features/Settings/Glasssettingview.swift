//
//  Glasssettingview.swift
//  AR_Runner_UI
//
//  Created by sym on 2026/10/05.
//
import SwiftUI

struct ARSettingsView: View {
    let onBack: () -> Void

    @State private var brightness: Double = 0.7
    @State private var voiceGuidance = true
    @State private var autoReconnect = true

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
                    Text("AR設定")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                    Text("ARグラスの表示・動作を調整します")
                        .font(.system(size: 14))
                        .foregroundColor(.arGrayText)
                        .padding(.top, 2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 28)
                .padding(.bottom, 24)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        // Brightness
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "sun.max.fill")
                                    .foregroundColor(.arYellow)
                                Text("明るさ")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(Int(brightness * 100))%")
                                    .font(.system(size: 13))
                                    .foregroundColor(.arGrayText)
                            }
                            Slider(value: $brightness)
                                .tint(.arYellow)
                        }
                        .padding(16)
                        .background(Color.arCard)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.arBorder, lineWidth: 1)
                        )

                        toggleRow(icon: "waveform", title: "音声ガイド", isOn: $voiceGuidance)
                        toggleRow(icon: "antenna.radiowaves.left.and.right", title: "自動再接続", isOn: $autoReconnect)
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
