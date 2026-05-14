//
//  LBStatisticsView.swift
//  LegionBet Sports Calc
//
//


import SwiftUI

struct LBStatisticsView: View {
    @EnvironmentObject private var currencyStore: CurrencySettingsStore
    @ObservedObject var viewModel: LBCclcViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        VStack(spacing: 0) {
            
            Image(.statsHeaderLB)
                .resizable()
                .scaledToFit()
                .background(.black)
            
            ScrollView {
                VStack(spacing: 16) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        MetricCard(
                            title: "WIN RATE",
                            value: formatPercent(winRate)
                        )

                        MetricCard(
                            title: "ROI",
                            value: formatPercent(roi, withPlus: true),
                            valueColor: roi >= 0 ? .lbGreen : .lbRed
                        )

                        MetricCard(
                            title: "AVG ODDS",
                            value: formatDecimal(avgOdds)
                        )

                        MetricCard(
                            title: "NET PROFIT",
                            value: formatMoney(netProfit),
                            valueColor: netProfit >= 0 ? .lbGreen : .lbRed
                        )
                    }

                    BetDistributionCard(
                        items: distributionItems
                    )

                    ProfitByDayCard(
                        items: profitByDayItems
                    )
                }
                .padding(20)
                .padding(.bottom, 150)
            }
            
        }
        .ignoresSafeArea(edges: .top)
        .background(.appBg)
    }
}

// MARK: - Calculations

private extension LBStatisticsView {
    var winBets: [Bet] {
        viewModel.bets.filter { $0.state == .win }
    }

    var loseBets: [Bet] {
        viewModel.bets.filter { $0.state == .lose }
    }

    var settledBets: [Bet] {
        viewModel.bets.filter {
            $0.state == .win || $0.state == .lose
        }
    }

    var winRate: Double {
        guard !settledBets.isEmpty else { return 0 }

        return Double(winBets.count) / Double(settledBets.count) * 100
    }

    var netProfit: Decimal {
        viewModel.bets.reduce(Decimal(0)) { result, bet in
            result + bet.netProfitValue
        }
    }

    var totalStakeForROI: Decimal {
        settledBets.reduce(Decimal(0)) { result, bet in
            result + bet.stake
        }
    }

    var roi: Double {
        guard totalStakeForROI > 0 else { return 0 }

        return netProfit.doubleValue / totalStakeForROI.doubleValue * 100
    }

    var avgOdds: Decimal {
        guard !viewModel.bets.isEmpty else { return 0 }

        let totalOdds = viewModel.bets.reduce(Decimal(0)) { result, bet in
            result + bet.totalOddsValue
        }

        return totalOdds / Decimal(viewModel.bets.count)
    }

    var distributionItems: [BetDistributionItem] {
        BetState.allCases.map { state in
            BetDistributionItem(
                state: state,
                count: viewModel.bets.filter { $0.state == state }.count
            )
        }
    }

    var profitByDayItems: [ProfitByDayItem] {
        let calendar = Calendar.current
        let titles = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

        var values = Array(repeating: Decimal(0), count: 7)

        for bet in viewModel.bets {
            let weekday = calendar.component(.weekday, from: bet.date)

            // Calendar: Sunday = 1, Monday = 2
            // Нужно: Monday = 0, Sunday = 6
            let index = (weekday + 5) % 7

            values[index] += bet.netProfitValue
        }

        return titles.enumerated().map { index, title in
            ProfitByDayItem(
                title: title,
                value: values[index]
            )
        }
    }
}

// MARK: - Cards

private struct MetricCard: View {
    let title: String
    let value: String
    var valueColor: Color = .white

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
                .tracking(2)

            Text(value)
                .font(.system(size: 32, weight: .black))
                .foregroundColor(valueColor)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(.cellFill)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.white.opacity(0.6), lineWidth: 1)
        )
        .cornerRadius(8)
    }
}

private struct BetDistributionCard: View {
    let items: [BetDistributionItem]

    var body: some View {
        VStack(spacing: 32) {
            Text("BET DISTRIBUTION")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
                .tracking(1.5)

            DonutChartView(items: items)
                .frame(width: 210, height: 210)

            VStack(spacing: 12) {
                ForEach(items) { item in
                    HStack {
                        Text(item.state.title.capitalized)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(item.state.color)

                        Spacer()

                        Text("\(item.count)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.cellFill)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.white.opacity(0.6), lineWidth: 1)
        )
        .cornerRadius(8)
    }
}

private struct ProfitByDayCard: View {
    let items: [ProfitByDayItem]

    var body: some View {
        VStack(spacing: 24) {
            Text("PROFIT BY DAY")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.lbSecondaryText)
                .tracking(1.5)

            ProfitBarChartView(items: items)
                .frame(height: 260)
        }
        .padding(16)
        .padding(.bottom, 16)
        .background(Color.cellFill)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.white.opacity(0.6), lineWidth: 1)
        )
        .cornerRadius(8)
    }
}

// MARK: - Donut Chart

private struct DonutChartView: View {
    let items: [BetDistributionItem]

    private var total: Double {
        Double(items.reduce(0) { $0 + $1.count })
    }

    var body: some View {
        ZStack {
            if total == 0 {
                Circle()
                    .stroke(Color.white.opacity(0.12), lineWidth: 32)
            } else {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    Circle()
                        .trim(
                            from: startValue(for: index),
                            to: endValue(for: index)
                        )
                        .stroke(
                            item.state.color,
                            style: StrokeStyle(
                                lineWidth: 32,
                                lineCap: .butt
                            )
                        )
                        .rotationEffect(.degrees(-90))
                }
            }
        }
    }

    private func startValue(for index: Int) -> CGFloat {
        guard total > 0 else { return 0 }

        let previous = items
            .prefix(index)
            .reduce(0) { $0 + $1.count }

        return CGFloat(Double(previous) / total)
    }

    private func endValue(for index: Int) -> CGFloat {
        guard total > 0 else { return 0 }

        let current = items
            .prefix(index + 1)
            .reduce(0) { $0 + $1.count }

        return CGFloat(Double(current) / total)
    }
}

// MARK: - Bar Chart

private struct ProfitBarChartView: View {
    let items: [ProfitByDayItem]

    private var maxValue: Double {
        let maxProfit = items
            .map { abs($0.value.doubleValue) }
            .max() ?? 0

        return max(maxProfit, 1)
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            VStack(alignment: .trailing) {
                ForEach([4, 3, 2, 1, 0], id: \.self) { step in
                    Text(axisText(for: step))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.lbSecondaryText)

                    if step != 0 {
                        Spacer()
                    }
                }
            }
            .frame(width: 36)

            GeometryReader { geometry in
                HStack(alignment: .bottom, spacing: 14) {
                    ForEach(items) { item in
                        VStack(spacing: 10) {
                            Spacer()

                            RoundedRectangle(cornerRadius: 8)
                                .fill(item.value >= 0 ? Color.lbGreen : Color.lbRed)
                                .frame(
                                    height: barHeight(
                                        value: item.value,
                                        maxHeight: geometry.size.height - 30
                                    )
                                )

                            Text(item.title)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.lbSecondaryText)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }

    private func barHeight(value: Decimal, maxHeight: CGFloat) -> CGFloat {
        let percentage = abs(value.doubleValue) / maxValue
        let height = CGFloat(percentage) * maxHeight

        return max(height, 2)
    }

    private func axisText(for step: Int) -> String {
        let value = maxValue * Double(step) / 4

        if value >= 1000 {
            return "\(Int(value / 1000))k"
        } else {
            return "\(Int(value))"
        }
    }
}

// MARK: - Helper Models

private struct BetDistributionItem: Identifiable {
    let state: BetState
    let count: Int

    var id: String {
        state.rawValue
    }
}

private struct ProfitByDayItem: Identifiable {
    let id = UUID()
    let title: String
    let value: Decimal
}

// MARK: - Bet Calculations

private extension Bet {
    var totalOddsValue: Decimal {
        let odds = events
            .map { $0.odd }
            .filter { $0 > 0 }

        guard !odds.isEmpty else {
            guard stake > 0 else { return 0 }
            return potentialWin / stake
        }

        return odds.reduce(Decimal(1)) { result, odd in
            result * odd
        }
    }

    var calculatedPotentialWin: Decimal {
        stake * totalOddsValue
    }

    var netProfitValue: Decimal {
        switch state {
        case .win:
            let winAmount = potentialWin > 0
                ? potentialWin
                : calculatedPotentialWin

            return winAmount - stake

        case .lose:
            return -stake

        case .refund:
            return 0

        case .inProgress:
            return 0
        }
    }
}

// MARK: - Formatters

private extension LBStatisticsView {
    func formatPercent(_ value: Double, withPlus: Bool = false) -> String {
        let prefix = withPlus && value > 0 ? "+" : ""
        return "\(prefix)\(String(format: "%.1f", value))%"
    }

    func formatDecimal(_ value: Decimal) -> String {
        String(format: "%.2f", value.doubleValue)
    }

    func formatMoney(_ value: Decimal) -> String {
        let prefix = value < 0 ? "-\(currencyStore.currencySymbol)" : "\(currencyStore.currencySymbol)"
        return "\(prefix)\(String(format: "%.2f", abs(value.doubleValue)))"
    }
}

private extension Decimal {
    var doubleValue: Double {
        NSDecimalNumber(decimal: self).doubleValue
    }
}

// MARK: - Colors

private extension Color {
    static let lbBackground = Color(red: 20 / 255, green: 18 / 255, blue: 18 / 255)
    static let lbCard = Color(red: 31 / 255, green: 29 / 255, blue: 29 / 255)
    static let lbBorder = Color.white.opacity(0.35)
    static let lbSecondaryText = Color.white.opacity(0.6)

    static let lbGreen = Color(red: 0 / 255, green: 210 / 255, blue: 75 / 255)
    static let lbRed = Color(red: 255 / 255, green: 63 / 255, blue: 69 / 255)
    static let lbYellow = Color(red: 245 / 255, green: 198 / 255, blue: 0 / 255)
}

private extension BetState {
    var color: Color {
        switch self {
        case .win:
            return .green
        case .lose:
            return .red
        case .inProgress:
            return .styleYellow
        case .refund:
            return .white
        }
    }
}

#Preview(body: {
    LBStatisticsView(viewModel: LBCclcViewModel())
        .environmentObject(CurrencySettingsStore())
})
