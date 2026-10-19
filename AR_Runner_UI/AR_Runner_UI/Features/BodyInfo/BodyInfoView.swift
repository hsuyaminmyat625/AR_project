//
//  BodyInfoView.swift
//  AR_Runner_UI
//
//  身体情報入力: gender, height, weight. All optional.
//  Used in the first-launch flow (after onboarding) and again from
//  スマホ設定 for editing.
//
import SwiftUI

struct BodyInfoView: View {
    /// true: first-launch flow ("次へ", no back button).
    /// false: editing from settings ("保存" + back button).
    let isInitialSetup: Bool
    let onNext: () -> Void
    let onBack: () -> Void

    @StateObject private var vm = BodyInfoViewModel()
    @FocusState private var focusedField: BodyField?
    @State private var pickerField: BodyField?

    var body: some View {
        ARScreen {
            VStack(spacing: 0) {
                navBar
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        genderSection
                        measurementCard(field: .height, text: $vm.heightText, error: vm.heightError)
                        measurementCard(field: .weight, text: $vm.weightText, error: vm.weightError)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                .scrollDismissesKeyboard(.interactively)

                footer
            }
        }
        .onChange(of: vm.heightText) { _, newValue in
            vm.handleInput(.height, newValue: newValue)
        }
        .onChange(of: vm.weightText) { _, newValue in
            vm.handleInput(.weight, newValue: newValue)
        }
        .onChange(of: focusedField) { oldValue, _ in
            if let oldValue {
                vm.revalidate(oldValue)
            }
        }
        .sheet(item: $pickerField) { field in
            WheelPickerSheet(
                title: field.title,
                unit: field.unit,
                range: field.range,
                initial: vm.pickerStartValue(for: field),
                onCancel: { pickerField = nil },
                onDone: { value in
                    vm.apply(pickerValue: value, to: field)
                    pickerField = nil
                }
            )
        }
    }

    // MARK: - Sections

    private var navBar: some View {
        HStack {
            if isInitialSetup {
                Color.clear.frame(width: 1, height: 44)
            } else {
                ARBackButton(action: onBack)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 56)
        .padding(.bottom, 16)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            ARLabel(text: "PROFILE")
            Text("身体情報")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
            Text(isInitialSetup
                 ? "すべて任意です。未入力でも次へ進めます。あとから設定で変更できます。"
                 : "すべて任意です。空欄のままでも保存できます。")
                .font(.system(size: 14))
                .foregroundColor(.arGrayText)
                .padding(.top, 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 28)
        .padding(.bottom, 20)
    }

    private var genderSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("性別")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.arGrayText)

            HStack(spacing: 10) {
                ForEach(Gender.allCases) { option in
                    let isSelected = vm.gender == option
                    Button {
                        vm.toggleGender(option)
                    } label: {
                        Text(option.label)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(isSelected ? .black : .white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(isSelected ? Color.arYellow : Color.arCard)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(isSelected ? Color.clear : Color.arBorder, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
        }
    }

    private func measurementCard(field: BodyField, text: Binding<String>, error: String?) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(field.title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.arGrayText)
                Spacer()
                Text("\(field.range.lowerBound)〜\(field.range.upperBound) \(field.unit)")
                    .font(.system(size: 12))
                    .foregroundColor(.arGrayText)
            }

            HStack(spacing: 10) {
                // Default keyboard on purpose: .numberPad would block full-width digits.
                TextField(field.placeholder, text: text)
                    .focused($focusedField, equals: field)
                    .submitLabel(.done)
                    .onSubmit { focusedField = nil }
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .tint(Color.arYellow)

                Text(field.unit)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.arGrayText)

                if !text.wrappedValue.isEmpty {
                    Button {
                        vm.clear(field)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.arGrayText)
                    }
                    .accessibilityLabel("\(field.title)をクリア")
                }

                Button {
                    focusedField = nil
                    pickerField = field
                } label: {
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.arYellow)
                        .frame(width: 36, height: 36)
                        .background(Color.arYellow.opacity(0.12))
                        .clipShape(Circle())
                }
                .accessibilityLabel("\(field.title)をピッカーで選ぶ")
            }

            if let error {
                Text(error)
                    .font(.system(size: 12))
                    .foregroundColor(.red)
            }
        }
        .padding(16)
        .background(Color.arCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor(for: field, hasError: error != nil), lineWidth: 1)
        )
    }

    private func borderColor(for field: BodyField, hasError: Bool) -> Color {
        if hasError { return .red }
        if focusedField == field { return .arYellow }
        return .arBorder
    }

    private var footer: some View {
        VStack(spacing: 12) {
            if let message = vm.saveError {
                Text(message)
                    .font(.system(size: 13))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            ARButton(isInitialSetup ? "次へ" : "保存") {
                focusedField = nil
                if vm.save(markSetupComplete: isInitialSetup) {
                    onNext()
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .padding(.bottom, 40)
    }
}

// MARK: - Drum-roll picker

private struct WheelPickerSheet: View {
    let title: String
    let unit: String
    let range: ClosedRange<Int>
    let onCancel: () -> Void
    let onDone: (Int) -> Void

    @State private var selection: Int

    init(
        title: String,
        unit: String,
        range: ClosedRange<Int>,
        initial: Int,
        onCancel: @escaping () -> Void,
        onDone: @escaping (Int) -> Void
    ) {
        self.title = title
        self.unit = unit
        self.range = range
        self.onCancel = onCancel
        self.onDone = onDone
        _selection = State(initialValue: initial)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("キャンセル", action: onCancel)
                    .foregroundColor(.arGrayText)
                Spacer()
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                Button("決定") { onDone(selection) }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.arYellow)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)

            Picker(title, selection: $selection) {
                ForEach(Array(range), id: \.self) { value in
                    Text("\(value) \(unit)").tag(value)
                }
            }
            .pickerStyle(.wheel)
        }
        .background(Color.arBG.ignoresSafeArea())
        .presentationDetents([.height(320)])
        .preferredColorScheme(.dark)
    }
}

#Preview {
    BodyInfoView(isInitialSetup: true, onNext: {}, onBack: {})
}
