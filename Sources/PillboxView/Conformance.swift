//
//  Conformance.swift
//  
//
//  Created by Jacob Trentini on 2/3/22.
//

import Foundation

extension PillView: Hashable {
    public static func == (lhs: PillView, rhs: PillView) -> Bool {
           lhs.pillView                 == rhs.pillView
        && lhs.width                    == rhs.width
        && lhs.height                   == rhs.height
        && lhs.activityIndicator        == rhs.activityIndicator
        && lhs.titleLabel               == rhs.titleLabel
        && lhs.isAwaitingTaskCompletion == rhs.isAwaitingTaskCompletion
        && lhs.successSymbol            == rhs.successSymbol
        && lhs.failureSymbol            == rhs.failureSymbol
        && lhs.errorSymbol              == rhs.errorSymbol
        && lhs.vcView                   == rhs.vcView
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(pillView)
        hasher.combine(width)
        hasher.combine(height)
        hasher.combine(activityIndicator)
        hasher.combine(titleLabel)
        hasher.combine(isAwaitingTaskCompletion)
        hasher.combine(successSymbol)
        hasher.combine(failureSymbol)
        hasher.combine(errorSymbol)
        hasher.combine(vcView)
    }
}
