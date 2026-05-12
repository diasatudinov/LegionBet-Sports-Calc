//
//  LBMenuView.swift
//  LegionBet Sports Calc
//
//

import SwiftUI

struct LBMenuContainer: View {
    @StateObject private var currencySettingsStore = CurrencySettingsStore()
    @AppStorage("firstOpenBB") var firstOpen: Bool = true
    
    var body: some View {
        NavigationStack {
            LBMenuView()
            
        }
        .environmentObject(currencySettingsStore)
    }
}

struct LBMenuView: View {
    @State var selectedTab = 0
//    @StateObject var dashboardVM = FADashboardViewModel()
    private let tabs = ["Calc", "Tracker", "Stats",  "Tips", "Settings"]
    
    var body: some View {
        ZStack(alignment: .bottom) {

            TabView(selection: $selectedTab) {
                LBCalcView()
                    .tag(0)
                
                Color.blue
                    .tag(1)
                
                Color.yellow
                    .tag(2)
                
                Color.green
                    .tag(3)
                
                LBSettingsView()
                    .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            customTabBar
        }
        .background(.appBg)
        .ignoresSafeArea(edges: .vertical)
    }
    
    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button {
                    selectedTab = index
                } label: {
                    VStack(spacing: 3) {
                        Image(selectedTab == index ? selectedIcon(for: index) : icon(for: index))
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                        
                        Text(tabs[index])
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(selectedTab == index ? .white : .white.opacity(0.6))
                            .padding(.bottom, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
                    .background(selectedTab == index ? .red : .clear)
                    .clipShape(RoundedRectangle(cornerRadius: 100))
                }
            }
        }
        .padding(4)
        .frame(maxWidth: .infinity)
        .background(.style.opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 296))
        .padding(.bottom, 20)
        .padding(.horizontal, 20)
    }
    
    private func icon(for index: Int) -> String {
        switch index {
        case 0: return "tab1IconFA"
        case 1: return "tab2IconFA"
        case 2: return "tab3IconFA"
        case 3: return "tab4IconFA"
        case 4: return "tab5IconFA"
        default: return ""
        }
    }
    
    private func selectedIcon(for index: Int) -> String {
        switch index {
        case 0: return "tab1IconSelectedFA"
        case 1: return "tab2IconSelectedFA"
        case 2: return "tab3IconSelectedFA"
        case 3: return "tab4IconSelectedFA"
        case 4: return "tab5IconSelectedFA"
        default: return ""
        }
    }
}
#Preview {
    LBMenuContainer()
}
