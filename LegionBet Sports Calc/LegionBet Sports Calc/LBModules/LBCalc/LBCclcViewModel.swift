//
//  LBCclcViewModel.swift
//  LegionBet Sports Calc
//
//

import SwiftUI

final class LBCclcViewModel: ObservableObject {
    @Published var bets: [Bet] = [
    ] {
        didSet {
            saveDashboard()
        }
    }
    
    private var dashboardFileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("bets.json")
    }
    
    init() {
        loadDashboard()
    }
    
    private func saveDashboard() {
        let url = dashboardFileURL
        do {
            let data = try JSONEncoder().encode(bets)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Failed to save teams:", error)
        }
    }
    
    private func loadDashboard() {
        let url = dashboardFileURL
        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let dashboardData = try JSONDecoder().decode([Bet].self, from: data)
            bets = dashboardData
        } catch {
            print("Failed to load teams:", error)
        }
    }
    
    
    func add(_ bet: Bet) {
        bets.append(bet)
    }
    
    func editBetState(bet: Bet, _ newState: BetState) {
        if let index = bets.firstIndex(where: { $0.id == bet.id }) {
            bets[index].state = newState
        }
    }
    
    func resetStatistics() {
        bets = []
    }
}
