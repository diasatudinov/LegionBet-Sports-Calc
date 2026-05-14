//
//  LBBetCell.swift
//  LegionBet Sports Calc
//
//

import SwiftUI

struct LBBetCell: View {
    @ObservedObject var viewModel: LBCclcViewModel
    let bet: Bet
    var currencySymbol: String
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(bet.type.title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                    .overlay {
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(.white.opacity(0.2))
                    }
                
                Text(formatDate(bet.date))
                    .font(.system(size: 10, weight: .regular))
                    .foregroundStyle(.white)
                
                
                Text(bet.state.title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(betStateColor(state: bet.state))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(betStateColor(state: bet.state).opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                    .overlay {
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(betStateColor(state: bet.state).opacity(0.3))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Rectangle()
                .fill(LinearGradient(colors: [.devider.opacity(0.1), .devider, .devider.opacity(0.1)], startPoint: .leading, endPoint: .trailing))
                .frame(height: 0.5)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(bet.events, id: \.id) { event in
                    
                    HStack {
                        Text(event.name)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white)
                            
                        
                        Text("\(event.odd)")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                            .overlay {
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(.white.opacity(0.2))
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
            
            Rectangle()
                .fill(LinearGradient(colors: [.devider.opacity(0.1), .devider, .devider.opacity(0.1)], startPoint: .leading, endPoint: .trailing))
                .frame(height: 0.5)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Stake")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                        .textCase(.uppercase)
                    
                    Text("\(currencySymbol)\(bet.stake)")
                        .font(.system(size: 20, weight: .black))
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Return")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                        .textCase(.uppercase)
                    
                    Text("\(currencySymbol)\(bet.potentialWin)")
                        .font(.system(size: 20, weight: .black))
                        .foregroundStyle(.green)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            if bet.state == .inProgress {
                HStack(spacing: 12) {
                    
                    ForEach(BetState.allCases, id: \.rawValue) { state in
                        if state != .inProgress {
                            HStack(spacing: 4) {
                                
                                Image(betStateIcon(state: state))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 14)
                                
                                Text(state.title)
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundStyle(betStateColor(state: state))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(betStateColor(state: state).opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                            .overlay {
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(betStateColor(state: state).opacity(0.3))
                            }
                            .onTapGesture {
                                viewModel.editBetState(bet: bet, state)
                            }
                            
                        }
                        
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
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
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    func betStateIcon(state: BetState) -> String {
        switch state {
        case .inProgress:
            return ""
        case .win:
            return "winIconLB"
        case .lose:
            return "loseIconLB"
        case .refund:
            return "refundIconLB"
        }
    }
    
    func betStateColor(state: BetState) -> Color {
        switch state {
        case .inProgress:
            return .styleYellow
        case .win:
            return .green
        case .lose:
            return .red
        case .refund:
            return .white
        }
    }
}

#Preview {
    LBBetCell(viewModel: LBCclcViewModel(), bet: Bet(type: .system, stake: 500, potentialWin: 2000, events: [
        Event(name: "Chelsea - Liverpool", odd: 2),
        Event(name: "Tennis", odd: 2)
    ], state: .inProgress), currencySymbol: "$")
}
