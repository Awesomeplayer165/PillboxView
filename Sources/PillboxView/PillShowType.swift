//
//  PillShowType.swift
//  PillboxView
//
//  Created by Jacob Trentini on 2/3/22.
//

/// Indicates the type of information that the ``PillboxView/PillView`` is showing.
public enum PillShowType {
    
    /// Indicates the ``PillboxView/PillView``'s purpose: to let the user know of an asynchronous task occurring in the background.
    ///
    /// This should not be used to display the status of a task that can be finished instantly. Usually, the coordinating function ``PillboxView/PillView/completedTask(state:completionHandler:)`` would be called in the completionHandler of your asynchronous task.
    ///
    /// An example of this asynchronous task can include a `URLSession.dataTask`. Some ideas of usage can be found at ``PillboxView/PillView/showType``.
    case ongoingTask
    
    ///Indicates the ``PillboxView/PillView``'s purpose: to let the user know of an error instantly.
    ///
    /// This should not be used for Network calls or any asynchronous tasks. Some ideas of usage can be found at ``PillboxView/PillView/showType``.
    case error
}
