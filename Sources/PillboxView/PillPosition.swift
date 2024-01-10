//
//  PillPosition.swift
//  ---

/// Defines the position of the ``PillboxView/PillView`` respective to it's view container as an offset
/// Also provide the ability to show the ``PillboxView/PillView`` appearing from the top ``fromTop`` or from the bottom
/// ``fromBottom`` of the container's edge
/// Default position is `.fromTop` with and offset of 25
import CoreGraphics

public struct PillPosition {
    enum AnimationDirection {
        case fromTop
        case fromBottom
    }
    var direction: AnimationDirection
    var offsetFromEdge: CGFloat
    
    init() {
        self.direction = .fromTop
        self.offsetFromEdge = CGFloat(25.0)
    }
}
