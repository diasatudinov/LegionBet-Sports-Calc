//
//  LBCclcViewModel.swift
//  LegionBet Sports Calc
//
//

import SwiftUI

final class LBCclcViewModel: ObservableObject {
    @Published var bets: [Bet] = [
        
    ]
    
    func add(_ bet: Bet) {
        bets.append(bet)
    }
    
}
