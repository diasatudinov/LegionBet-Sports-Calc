//
//  LBSettingsView.swift
//  LegionBet Sports Calc
//
//

import SwiftUI

struct LBSettingsView: View {
    @EnvironmentObject private var currencyStore: CurrencySettingsStore
    @State private var initial: String = "1000"
    
    var body: some View {
        VStack(spacing: 0) {
            
            Image(.settingsHeaderLB)
                .resizable()
                .scaledToFit()
                .background(.black)
            
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 12) {
                        
                        Text("Primary Currency")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            ForEach(AppCurrency.allCases) { currency in
                                Button {
                                    currencyStore.selectedCurrency = currency
                                } label: {
                                    Text(currency.symbol)
                                        .font(.title2)
                                        .frame(width: 40)
                                    
                                }
                                .frame(width: 99, height: 55)
                                .background(currencyStore.selectedCurrency == currency ? Gradients.accentBtn.color : Gradients.appBg.color)
                                .foregroundColor(currencyStore.selectedCurrency == currency ? .appBg : .white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 1)
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 16)
                    .background(.cellFill)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    
                    VStack(spacing: 12) {
                        
                        Text("Starting Bankroll")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 4) {
                            Text(currencyStore.selectedCurrency.symbol)
                            
                            TextField("", text: $initial)
                                .font(.system(size: 14, weight: .medium))
                                .keyboardType(.decimalPad)
                        }
                        .padding(6)
                        .padding(.horizontal, 6)
                        .background(Gradients.appBg.color)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1)
                                .foregroundStyle(.white)
                        }
                        
                        Text("Used to calculate your initial ROI and total profit margins accurately.")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundStyle(.white.opacity(0.7))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 16)
                    .background(.cellFill)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    
                    
                    VStack(spacing: 12) {
                        Text("Danger Zone")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                    
                                
                                Text("Reset All Statistics")
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.red)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(.red.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(.red.opacity(0.3))
                            }
                        }
                        
                    }
                    
                    VStack(spacing: 12) {
                        
                        Image(.settingsIconLB)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 32)
                        
                        VStack(spacing: 4) {
                            
                            Text("LegionBet - Sports Calc")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Text("Version 1.0.0")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.white.opacity(0.7))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                
                            
                            Text("18+ Play Responsibly")
                        }
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.red)
                        .padding(.vertical, 8.5)
                        .padding(.horizontal,16)
                        .background(.red.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1)
                                .foregroundStyle(.red.opacity(0.3))
                        }
                        
                        Text("This app is a calculator and tracker only. It does not accept real money bets or provide gambling services.")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundStyle(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 16)
                    .background(.cellFill)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 150)
               
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(.appBg)
        
    }
    
    
}

#Preview {
    LBSettingsView()
        .environmentObject(CurrencySettingsStore())
}
