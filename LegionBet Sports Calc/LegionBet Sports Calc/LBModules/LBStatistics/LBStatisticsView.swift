import SwiftUI

struct LBStatisticsView: View {
    @ObservedObject var viewModel: LBCclcViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
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
        }
        .background(Color.lbBackground.ignoresSafeArea())
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
        VStack(spacing: 16) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.lbSecondaryText)
                .tracking(2)

            Text(value)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(valueColor)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 130)
        .background(Color.lbCard)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.lbBorder, lineWidth: 1)
        )
        .cornerRadius(10)
    }
}

private struct BetDistributionCard: View {
    let items: [BetDistributionItem]

    var body: some View {
        VStack(spacing: 24) {
            Text("BET DISTRIBUTION")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.lbSecondaryText)
                .tracking(1.5)

            DonutChartView(items: items)
                .frame(width: 210, height: 210)

            VStack(spacing: 18) {
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
        .padding(24)
        .background(Color.lbCard)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.lbBorder, lineWidth: 1)
        )
        .cornerRadius(10)
    }
}

private struct ProfitByDayCard: View {
    let items: [ProfitByDayItem]

    var body: some View {
        VStack(spacing: 24) {
            Text("PROFIT BY DAY")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.lbSecondaryText)
                .tracking(1.5)

            ProfitBarChartView(items: items)
                .frame(height: 260)
        }
        .padding(24)
        .background(Color.lbCard)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.lbBorder, lineWidth: 1)
        )
        .cornerRadius(10)
    }
}