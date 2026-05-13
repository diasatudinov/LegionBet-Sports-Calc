//
//  LBTipCell.swift
//  LegionBet Sports Calc
//
//

import SwiftUI

struct LBTipCell: View {
    var title: String
    var content: [Cell]
    
    @State private var isOpened = false
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.down")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 10)
                    .rotationEffect(.degrees(isOpened ? 180 : 0))
            }
            .foregroundStyle(.styleYellow)
            
            if isOpened {
                VStack(spacing: 12) {
                    
                    Rectangle()
                        .fill(LinearGradient(colors: [.devider.opacity(0.1), .devider, .devider.opacity(0.1)], startPoint: .leading, endPoint: .trailing))
                        .frame(height: 1)
                    
                    ForEach(content.indices, id: \.self) { index in
                        let tip = content[index]
                        
                        VStack(spacing: 6) {
                            Text(tip.title)
                                .font(.system(size: 15, weight: .medium))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(.styleRed)
                            
                            Text(tip.description)
                                .font(.system(size: 12, weight: .regular))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(.white)
                            
                            if index != content.count - 1 {
                                Rectangle()
                                    .fill(LinearGradient(colors: [.devider.opacity(0.1), .devider, .devider.opacity(0.1)], startPoint: .leading, endPoint: .trailing))
                                    .frame(height: 1)
                                    .padding(.top, 7)
                            }
                               
                        }
                    }
                }
            }
            
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 20)
        .background(.cellFill)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .foregroundStyle(.white.opacity(0.7))
        }
        .onTapGesture {
            withAnimation {
                isOpened.toggle()
            }
        }
    }
}

#Preview {
    LBTipCell(title: "Mathematics & Calculations", content: [
        Cell(title: "Flat Betting - Discipline Foundation", description: "Bet a fixed % of your bankroll (1-3%) on each event. This protects against rapid losses."),
        Cell(title: "Find Value, Not Winners", description: "Only bet when your odds are higher than the bookmaker's. Mathematical advantage beats intuition."),
        Cell(title: "Calculate Bookmaker Margin", description: "Understand how much the bookmaker takes. Avoid markets with margin >7-8%."),
        Cell(title: "Avoid Long Parlays", description: "Each added coefficient multiplies the bookmaker's margin. 2-3 events is optimal."),
        Cell(title: "Track Every Bet", description: "Without a journal, you won't see your weak spots. Record everything: date, amount, odds, outcome.")
    ])
}
