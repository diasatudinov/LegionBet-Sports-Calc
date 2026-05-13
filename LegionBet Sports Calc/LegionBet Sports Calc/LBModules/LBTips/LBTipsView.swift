//
//  LBTipsView.swift
//  LegionBet Sports Calc
//
//

import SwiftUI

struct LBTipsView: View {
    @StateObject private var viewModel = LBTipsViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            
            Image(.tipsHeaderLB)
                .resizable()
                .scaledToFit()
                .background(.black)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.tips, id: \.id) { tip in
                        LBTipCell(title: tip.title, content: tip.tips)
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
    LBTipsView()
}
