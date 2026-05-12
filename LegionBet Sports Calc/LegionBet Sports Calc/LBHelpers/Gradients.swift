//
//  Gradients.swift
//  LegionBet Sports Calc
//
//
import SwiftUI

enum Gradients {
    case accentBtn, clear, appBg
    
    var color: Gradient {
        switch self {
        case .accentBtn:
            Gradient(colors: [.linear1, .linear2])
        case .clear:
            Gradient(colors: [.clear])
        case .appBg:
            Gradient(colors: [.appBg])
        
        }
    }
}
