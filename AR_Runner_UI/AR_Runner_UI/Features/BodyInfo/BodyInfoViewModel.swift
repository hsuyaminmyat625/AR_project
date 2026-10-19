//
//  BodyInfoViewModel.swift
//  AR_Runner_UI
//
//  Input handling + validation for the 身体情報 screen.
//
import Foundation
import Combine

// MARK: - Numeric fields

enum BodyField: Identifiable {
    case height
    case weight

    var id: Self { self }

    var title: String { self == .height ? "身長" : "体重" }
    var unit: String { self == .height ? "cm" : "kg" }
    var placeholder: String { self == .height ? "170" : "60" }
    var pickerDefault: Int { self == .height ? 170 : 60 }
    var range: ClosedRange<Int> {
        self == .height ? BodyInfo.heightRange : BodyInfo.weightRange
    }
}

// MARK: - ViewModel

final class BodyInfoViewModel: ObservableObject {

    @Published var heightText = ""
    @Published var weightText = ""
    @Published var gender: Gender?

    @Published private(set) var heightError: String?
    @Published private(set) var weightError: String?
    @Published private(set) var saveError: String?

    private let store: BodyInfoStore

    /// Text we wrote back ourselves while correcting input. The resulting
    /// onChange callback is ignored so it doesn't clear the error we just set.
    private var pendingCorrection: [BodyField: String] = [:]

    private let invalidCharacterMessage = "半角または全角の数字で入力してください"

    init(store: BodyInfoStore = .shared) {
        self.store = store
        let info = store.load()
        heightText = info.heightCm.map { String($0) } ?? ""
        weightText = info.weightKg.map { String($0) } ?? ""
        gender = info.gender
    }

    // MARK: Gender

    func toggleGender(_ value: Gender) {
        gender = (gender == value) ? nil : value
    }

    // MARK: Typing

    /// Called every time a text field changes.
    /// - Full-width digits are converted to half-width.
    /// - Anything that isn't a digit is removed and an error is shown.
    /// - Values above the maximum are blocked while typing (e.g. a third "9"
    ///   in 999 cm never appears).
    /// Values below the minimum can't be blocked per keystroke ("1" is on the
    /// way to "170"), so they are checked when the field loses focus and when
    /// saving.
    func handleInput(_ field: BodyField, newValue: String) {
        if pendingCorrection[field] == newValue {
            pendingCorrection[field] = nil
            return
        }
        pendingCorrection[field] = nil

        let normalized = Self.toHalfWidth(newValue)
        var digits = normalized.filter { $0.isASCII && $0.isNumber }
        var message: String?

        if digits.count != normalized.count {
            message = invalidCharacterMessage
        }

        while digits.hasPrefix("0") {
            digits.removeFirst()
        }

        if digits.count > 3 {
            digits = String(digits.prefix(3))
            message = rangeMessage(for: field)
        }

        while let value = Int(digits), value > field.range.upperBound {
            digits.removeLast()
            message = rangeMessage(for: field)
        }

        setError(message, for: field)

        if digits != newValue {
            pendingCorrection[field] = digits
            setText(digits, for: field)
        }
    }

    /// Re-checks a field (used when it loses focus and before saving).
    func revalidate(_ field: BodyField) {
        if let value = Int(text(for: field)), !field.range.contains(value) {
            setError(rangeMessage(for: field), for: field)
        } else {
            setError(nil, for: field)
        }
    }

    func clear(_ field: BodyField) {
        setText("", for: field)
        setError(nil, for: field)
    }

    // MARK: Wheel picker

    func pickerStartValue(for field: BodyField) -> Int {
        if let value = Int(text(for: field)), field.range.contains(value) {
            return value
        }
        return field.pickerDefault
    }

    func apply(pickerValue: Int, to field: BodyField) {
        setText(String(pickerValue), for: field)
        setError(nil, for: field)
    }

    // MARK: Save

    /// Returns true when saved. On failure the screen stays and shows an error.
    func save(markSetupComplete: Bool) -> Bool {
        saveError = nil

        revalidate(.height)
        revalidate(.weight)
        guard heightError == nil, weightError == nil else { return false }

        let info = BodyInfo(
            heightCm: Int(heightText),
            weightKg: Int(weightText),
            gender: gender
        )

        do {
            try store.save(info)
            if markSetupComplete {
                store.hasCompletedInitialSetup = true
            }
            return true
        } catch {
            saveError = "保存に失敗しました。もう一度お試しください。"
            return false
        }
    }

    // MARK: Helpers

    private func rangeMessage(for field: BodyField) -> String {
        "\(field.title)は\(field.range.lowerBound)〜\(field.range.upperBound)\(field.unit)の範囲で入力してください"
    }

    private func text(for field: BodyField) -> String {
        field == .height ? heightText : weightText
    }

    private func setText(_ value: String, for field: BodyField) {
        if field == .height {
            heightText = value
        } else {
            weightText = value
        }
    }

    private func setError(_ message: String?, for field: BodyField) {
        if field == .height {
            heightError = message
        } else {
            weightError = message
        }
    }

    private static func toHalfWidth(_ string: String) -> String {
        string.applyingTransform(.fullwidthToHalfwidth, reverse: false) ?? string
    }
}
