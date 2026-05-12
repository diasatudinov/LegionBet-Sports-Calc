//
//  LBCclcViewModel.swift
//  LegionBet Sports Calc
//
//  Created by Dias Atudinov on 12.05.2026.
//

import SwiftUI

final class LBCclcViewModel: ObservableObject {
    @Published private(set) var balanceText: String = ""
    @Published private(set) var selectedCurrency: AppCurrency

    private var balance: Decimal = 125_000
    private let settingsStore: CurrencySettingsStore

    init(settingsStore: CurrencySettingsStore) {
        self.settingsStore = settingsStore
        self.selectedCurrency = settingsStore.selectedCurrency

    }

    func addMoney() {
        balance += Decimal(10_000)
    }

    func removeMoney() {
        balance -= Decimal(10_000)
    }

    
}
