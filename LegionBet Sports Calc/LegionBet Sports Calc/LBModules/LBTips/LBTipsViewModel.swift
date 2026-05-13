//
//  LBTipsViewModel.swift
//  LegionBet Sports Calc
//
//

import Foundation

final class LBTipsViewModel: ObservableObject {
    let tips: [Tip] = [
        Tip(title: "Mathematics & Calculations", tips: [
            Cell(title: "Flat Betting - Discipline Foundation", description: "Bet a fixed % of your bankroll (1-3%) on each event. This protects against rapid losses."),
            Cell(title: "Find Value, Not Winners", description: "Only bet when your odds are higher than the bookmaker's. Mathematical advantage beats intuition."),
            Cell(title: "Calculate Bookmaker Margin", description: "Understand how much the bookmaker takes. Avoid markets with margin >7-8%."),
            Cell(title: "Avoid Long Parlays", description: "Each added coefficient multiplies the bookmaker's margin. 2-3 events is optimal."),
            Cell(title: "Track Every Bet", description: "Without a journal, you won't see your weak spots. Record everything: date, amount, odds, outcome.")
        ]),
        Tip(title: "Strategy & Bankroll Management", tips: [
            Cell(title: "Define Bankroll in Advance", description: "Set aside money you're prepared to lose. Never bet money meant for living expenses."),
            Cell(title: "Don't Chase Losses", description: "Chasing strategy (increasing stake after loss) is a fast path to bankruptcy."),
            Cell(title: "Bet What You Know", description: "Don't chase trending leagues. Expertise in a narrow niche gives you an edge."),
            Cell(title: "Avoid \"Sure Things\" with Low Odds", description: "Odds of 1.10-1.20 aren't worth the risk: one surprise wipes out 5-10 wins."),
            Cell(title: "Separate Emotions from Decisions", description: "Don't bet on your favorite team \"for love\". Analyze objectively, like any other match.")
        ]),
        Tip(title: "Psychology & Discipline", tips: [
            Cell(title: "Accept Variance", description: "Even with correct bets, there will be losing streaks. That's normal. Focus on the long game."),
            Cell(title: "Don't Bet to \"Win It Back\"", description: "Lost? Take a break. Emotional bets after defeat are the biggest mistake."),
            Cell(title: "Record Bet Reasoning", description: "Write why you placed each bet. This helps analyze mistakes and find patterns."),
            Cell(title: "Set Limits", description: "Define maximum bets per day/week. Discipline matters more than one \"golden\" bet."),
            Cell(title: "Don't Trust \"Guaranteed Predictions\"", description: "If someone knew 100% outcomes, they wouldn't sell predictions for $50.")
        ]),
        Tip(title: "Analysis & Research", tips: [
            Cell(title: "Compare Odds", description: "Open accounts with multiple bookmakers. A difference of 0.10-0.20 gives +10-20% profit long-term."),
            Cell(title: "Analyze Context, Not Just Teams", description: "Injuries, motivation, weather, referee, schedule - everything affects the outcome."),
            Cell(title: "Monitor Line Movement", description: "Sharp odds drop may signal important news (injury, lineup). Use this information."),
            Cell(title: "Don't Bet on Everything", description: "Better to have 2-3 quality analyses per week than 10 random bets. Quality over quantity."),
            Cell(title: "Review Strategy Monthly", description: "Analyze statistics: which markets bring profit, which bring loss. Adapt accordingly.")
        ]),
    ]
}

struct Tip {
    let id = UUID()
    var title: String
    var tips: [Cell]
}

struct Cell {
    let id = UUID()
    var title: String
    var description: String
}
