//
//  BodyInfo.swift
//  AR_Runner_UI
//
//  Model + persistence for the 身体情報 (physical information) screen.
//  Every field is optional: users may leave any of them blank.
//
import Foundation

// MARK: - Gender

enum Gender: String, Codable, CaseIterable, Identifiable {
    case male
    case female
    case other

    var id: String { rawValue }

    var label: String {
        switch self {
        case .male:   return "男性"
        case .female: return "女性"
        case .other:  return "その他"
        }
    }
}

// MARK: - BodyInfo

struct BodyInfo: Codable, Equatable {
    var heightCm: Int?
    var weightKg: Int?
    var gender: Gender?

    static let heightRange = 50...300   // cm
    static let weightRange = 10...300   // kg

    static let empty = BodyInfo(heightCm: nil, weightKg: nil, gender: nil)
}

// MARK: - Store

enum BodyInfoStoreError: Error {
    case saveFailed
}

/// Saves/loads BodyInfo (UserDefaults for now) and remembers whether the
/// first-launch input screen has been completed.
struct BodyInfoStore {
    static let shared = BodyInfoStore()

    private let defaults: UserDefaults
    private let infoKey = "bodyInfo"
    private let completedKey = "hasCompletedBodyInfoSetup"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    /// True once the user has passed the first-launch 身体情報 screen
    /// (even if they left every field blank).
    var hasCompletedInitialSetup: Bool {
        get { defaults.bool(forKey: completedKey) }
        nonmutating set { defaults.set(newValue, forKey: completedKey) }
    }

    func load() -> BodyInfo {
        guard
            let data = defaults.data(forKey: infoKey),
            let info = try? JSONDecoder().decode(BodyInfo.self, from: data)
        else {
            return .empty
        }
        return info
    }

    func save(_ info: BodyInfo) throws {
        do {
            let data = try JSONEncoder().encode(info)
            defaults.set(data, forKey: infoKey)
        } catch {
            throw BodyInfoStoreError.saveFailed
        }
    }
}
