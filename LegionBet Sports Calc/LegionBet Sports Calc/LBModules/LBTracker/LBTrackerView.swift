//
//  LBTrackerView.swift
//  LegionBet Sports Calc
//
//

import SwiftUI

struct LBTrackerView: View {
    @EnvironmentObject private var currencyStore: CurrencySettingsStore
    @ObservedObject var viewModel: LBCclcViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            Image(.trackerHeaderLB)
                .resizable()
                .scaledToFit()
                .background(.black)
            
            ScrollView {
                VStack(spacing: 16) {
                    if viewModel.bets.isEmpty {
                        VStack {
                            Text("No bets found")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.styleRed)
                                .textCase(.uppercase)
                            
                            Text("Start by adding a bet from the calculator")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(.white)
                            
                        }
                        .padding(.top, 100)
                    } else {
                        ForEach(viewModel.bets, id: \.id) { bet in
                            LBBetCell(viewModel: viewModel, bet: bet, currencySymbol: currencyStore.currencySymbol)
                        }
                    }
                }
                .padding(20)
                .padding(.bottom, 150)
            }
            
        }
        .ignoresSafeArea(edges: .top)
        .background(.appBg)
    }
}

#Preview {
    LBTrackerView(viewModel: LBCclcViewModel())
        .environmentObject(CurrencySettingsStore())
}
