//
//  LBCalcView.swift
//  LegionBet Sports Calc
//
//

import SwiftUI

struct LBCalcView: View {
    @EnvironmentObject private var currencyStore: CurrencySettingsStore
    var body: some View {
        VStack(spacing: 0) {
            
            Image(.calcHeaderLB)
                .resizable()
                .scaledToFit()
                .background(.black)
                
           
            Text("Главный экран")
                .font(.title)
            
            Text("Валюта: \(currencyStore.currencySymbol)")
                .font(.system(size: 40, weight: .bold))
            
            Text("\(currencyStore.currencySymbol) 150 000")
                .font(.title2)
            
            ScrollView {
                
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    LBCalcView()
        .environmentObject(CurrencySettingsStore())
}
