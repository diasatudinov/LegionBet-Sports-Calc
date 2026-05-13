//
//  LBCalcView.swift
//  LegionBet Sports Calc
//
//

import SwiftUI

enum BetType: String, CaseIterable {
    case single, accumulator, system, flat
    
    var title: String {
        switch self {
        case .single:
            "Single"
        case .accumulator:
            "Accumulator"
        case .system:
            "System"
        case .flat:
            "Flat"
        }
    }
}
struct LBCalcView: View {
    @EnvironmentObject private var currencyStore: CurrencySettingsStore
    @ObservedObject var viewModel: LBCclcViewModel
    @State private var type: BetType = .single
    @State private var amount: String = ""
    @State private var eventName: String = ""
    @State private var eventOdd: String = ""
    @State private var events: [Event] = []
    @State private var areFieldsEmpty = false
    
    private var currentEventOdd: Decimal? {
        guard let value = eventOdd.decimalValue, value > 0 else {
            return nil
        }

        return value
    }
    
    private var stakeDecimal: Decimal {
        amount.decimalValue ?? 0
    }
    
    private var totalOdds: Decimal {
        calculateTotalOdds(
            events: events,
            currentOdd: currentEventOdd
        )
    }

    private var potentialWin: Decimal {
        stakeDecimal * totalOdds
    }

    private var netProfit: Decimal {
        potentialWin - stakeDecimal
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            Image(.calcHeaderLB)
                .resizable()
                .scaledToFit()
                .background(.black)
            
//            Text("Валюта: \(currencyStore.currencySymbol)")
//                .font(.system(size: 40, weight: .bold))
//            
//            Text("\(currencyStore.currencySymbol) 150 000")
//                .font(.title2)
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack(spacing: 0) {
                        ForEach(BetType.allCases, id: \.self) { type in
                            Text(type.title)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(self.type == type ? .appBg : .white)
                                .lineLimit(1)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .background(self.type == type ? Gradients.accentBtn.color : Gradients.clear.color)
                                .clipShape(RoundedRectangle(cornerRadius: 7))
                                .onTapGesture {
                                    withAnimation(.smooth) {
                                        self.type = type
                                    }
                                }
                            
                            if type != .flat {
                                Rectangle()
                                    .fill(Gradients.accentBtn.color)
                                    .frame(width: 0.5, height: 16)
                            }
                        }
                    }
                    .padding(2)
                    .background(.cellFill)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(Gradients.accentBtn.color)
                    }
                    .padding(.horizontal, 40)
                    
                    VStack(spacing: 20) {
                        VStack(spacing: 12) {
                            Text("Stake Amount")
                                .font(.system(size: 16, weight: .medium))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(.white)
                            
                            TextField("", text: $amount)
                                .keyboardType(.decimalPad)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 14)
                                .background(.cellFill)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 1)
                                        .foregroundStyle(.white.opacity(0.7))
                                }
                                .overlay {
                                    if amount.isEmpty {
                                        Text("0.00")
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(.white.opacity(0.6))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 12)
                                            .allowsHitTesting(false)
                                    }
                                }
                        }
                        
                        VStack(spacing: 16) {
                            Text("Events & Odds")
                                .font(.system(size: 16, weight: .medium))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(.white)
                            
                            VStack(spacing: 12) {
                                ForEach(events, id: \.id) { event in
                                    HStack {
                                        HStack {
                                            Text("\(event.name)")
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundStyle(.white)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Button {
                                                delete(event)
                                            } label: {
                                                Image(.deleteIconLB)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 15)
                                            }
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 14)
                                        .background(.cellFill)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(lineWidth: 1)
                                                .foregroundStyle(.white.opacity(0.7))
                                        }
                                            
                                        
                                        Text("\(event.odd)")
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(.white)
                                            .padding(.vertical, 14)
                                            .frame(width: 90)
                                            .background(.cellFill)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(lineWidth: 1)
                                                    .foregroundStyle(.white.opacity(0.7))
                                            }
                                            
                                        
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        TextField("", text: $eventName)
                                            .keyboardType(.default)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 14)
                                            .background(.cellFill)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(lineWidth: 1)
                                                    .foregroundStyle(.white.opacity(0.7))
                                            }
                                            .overlay {
                                                if eventName.isEmpty {
                                                    Text("Event Name")
                                                        .font(.system(size: 13, weight: .medium))
                                                        .foregroundStyle(.white.opacity(0.6))
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .padding(.leading, 12)
                                                        .allowsHitTesting(false)
                                                }
                                            }
                                        
                                        TextField("2.5", text: $eventOdd)
                                            .keyboardType(.decimalPad)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 14)
                                            .frame(width: 90)
                                            .background(.cellFill)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(lineWidth: 1)
                                                    .foregroundStyle(.white.opacity(0.7))
                                            }
                                            .overlay {
                                                if eventOdd.isEmpty {
                                                    Text("2.50")
                                                        .font(.system(size: 13, weight: .medium))
                                                        .foregroundStyle(.white.opacity(0.6))
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .padding(.leading, 20)
                                                        .allowsHitTesting(false)
                                                }
                                            }
                                        
                                    }
                                    
                                    if areFieldsEmpty {
                                        Text("Field is empty")
                                            .font(.system(size: 10, weight: .regular))
                                            .foregroundStyle(.red)
                                    } else {
                                        Text("Field is empty")
                                            .font(.system(size: 10, weight: .regular))
                                            .foregroundStyle(.clear)
                                    }
                                        
                                }
                            }
                            
                            if type != .single {
                                Button {
                                    if eventName.isEmpty || eventOdd.isEmpty {
                                        areFieldsEmpty = true
                                    } else {
                                        let event = Event(name: eventName, odd: stringToDecimal(eventOdd) ?? 0.0)
                                        events.append(event)
                                        eventName = ""
                                        eventOdd = ""
                                        areFieldsEmpty = false
                                    }
                                } label: {
                                    Text("+ Add Event")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 14)
                                        .background(.appBg)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(lineWidth: 1)
                                                .foregroundStyle(.white.opacity(0.7))
                                        }
                                }
                            }
                            
                            VStack(spacing: 16) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Total Odds")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundStyle(.white)
                                        
                                        Text("\(totalOdds)")
                                            .font(.system(size: 24, weight: .black))
                                            .foregroundStyle(.white)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Net Profit")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundStyle(.white)
                                        
                                        Text("\(currencyStore.currencySymbol) \(netProfit)")
                                            .font(.system(size: 24, weight: .black))
                                            .foregroundStyle(.green)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                Rectangle()
                                    .fill(LinearGradient(colors: [.devider.opacity(0.1), .devider, .devider.opacity(0.1)], startPoint: .leading, endPoint: .trailing))
                                    .frame(height: 0.5)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Potential Win")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(.winText)
                                        .textCase(.uppercase)
                                    
                                    Text("\(currencyStore.currencySymbol) \(potentialWin)")
                                        .font(.system(size: 32, weight: .black))
                                        .foregroundStyle(.winText)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(.cellFill)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                            
                            Button {
                                if eventName.isEmpty || eventOdd.isEmpty {
                                    areFieldsEmpty = true
                                } else {
                                    
                                    let event = Event(name: eventName, odd: stringToDecimal(eventOdd) ?? 0.0)
                                    events.append(event)
                                    eventName = ""
                                    eventOdd = ""
                                    areFieldsEmpty = false
                                    
                                    
                                    let bet = Bet(type: type, stake: stakeDecimal, potentialWin: potentialWin, events: events)
                                    viewModel.add(bet)
                                    
                                    events = []
                                    amount = ""
                                }
                                
                                
                               
                            } label: {
                                Text("Save Bet")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.appBg)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 14)
                                    .background(Gradients.accentBtn.color)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(lineWidth: 1)
                                            .foregroundStyle(.white.opacity(0.7))
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    
                }
                .padding(.top, 20)
                .padding(.bottom, 150)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(.appBg)
    }
    
    private func stringToDecimal(_ text: String) -> Decimal? {
        let normalizedText = text
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: ".")

        return Decimal(string: normalizedText)
    }
    
    private func delete(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id}) {
            events.remove(at: index)
        }
    }
    
    func calculateTotalOdds(
        events: [Event],
        currentOdd: Decimal?
    ) -> Decimal {
        let savedOdds = events.map { $0.odd }.filter { $0 > 0 }

        var allOdds = savedOdds

        if let currentOdd {
            allOdds.append(currentOdd)
        }

        guard !allOdds.isEmpty else {
            return 0
        }

        return allOdds.reduce(Decimal(1)) { result, odd in
            result * odd
        }
    }
}

#Preview {
    LBCalcView(viewModel: LBCclcViewModel())
        .environmentObject(CurrencySettingsStore())
}

struct Event {
    let id = UUID()
    var name: String
    var odd: Decimal
}

extension String {
    var decimalValue: Decimal? {
        let normalized = self
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: ".")

        return Decimal(string: normalized)
    }
}

struct Bet {
    let id = UUID()
    var type: BetType
    var stake: Decimal
    var potentialWin: Decimal
    var events: [Event]
    var state: BetState = .inProgress
    var date: Date = .now
}

enum BetState {
    case inProgress, win, lose, refund
}
