//
//  LBSettingsViewModel.swift
//  LegionBet Sports Calc
//
//

import Foundation

final class CurrencySettingsStore: ObservableObject {
    @Published var selectedCurrency: AppCurrency {
        didSet {
            UserDefaults.standard.set(selectedCurrency.rawValue, forKey: Self.currencyKey)
        }
    }

    private static let currencyKey = "selected_currency"

    init() {
        let savedValue = UserDefaults.standard.string(forKey: Self.currencyKey)

        if let savedValue,
           let currency = AppCurrency(rawValue: savedValue) {
            selectedCurrency = currency
        } else {
            selectedCurrency = .usd
        }
    }

    var currencySymbol: String {
        selectedCurrency.symbol
    }
}

enum AppCurrency: String, CaseIterable, Identifiable {
    case usd = "USD"
    case eur = "EUR"

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .usd:
            return "Доллар США"
        case .eur:
            return "Евро"
        }
    }

    var symbol: String {
        switch self {
        case .usd:
            return "$"
        case .eur:
            return "€"
        }
    }

}
