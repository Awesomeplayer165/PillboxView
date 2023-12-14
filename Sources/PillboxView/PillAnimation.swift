//
//  PillPosition.swift
//  
//
//  Created by Martin Dufort on 2023-12-14.
//


/// Defines the direction from which the ``PillboxView/PillView`` will appear and also the offset from the edge of
/// the containing view to where it will rest. This allows stop coordinates to be different if showing from bottom versus
/// showing from top.
///
/// It also removes the need to inform the ``PillboxView/PillView`` about the presence of a navigation controller.
import CoreGraphics

public struct PillAnimation {
    enum AnimationDirection {
        case fromTop
        case fromBottom
    }
    var direction: AnimationDirection
    var offsetFromEdge: CGFloat
}
