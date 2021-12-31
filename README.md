# Pillbox View

Pillbox View shows a small bubble, pill looking box that sides from the top of the screen. You have seen this throughout iOS when the ringer state is changed and Airpods are connected, among others.

## Features

- Display a title message
- Show an activity indicator to show ongoing activity
  - Indicate your task's success with a green checkmark or failure with a red x

## Installation

Copy the `PillBoxViewManager` into your file project/manager. Because I have not opened up to Cocoapods, you will have to be your own dependency manager and check for frequent updates while I am setting up dependency managers.

## Quick Start

```swift
import UIKit

class ViewController: UIViewController {

    let pill = PillBoxViewManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pill.show(title: "Refreshing Data", vcView: self.view)
        
        // some time later...
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          pill.didFinishTask = true // this indicates the task's success
        }
    }
}

```

All you have to do is pass in a title message and your view controller's `UIView`

## Conclusion

Let me know how this is and help me improve this project with ideas, suggestions.

## Created and Maintained by:

[Jacob Trentini](https://github.com/Awesomeplayer165)
