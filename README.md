# Pillbox View

Pillbox View shows a small bubble, pill looking box that sides from the top of the screen. You have seen this throughout iOS when the ringer state is changed and Airpods are connected, among others.

![IMG_A7E525EB0B26-1](https://user-images.githubusercontent.com/70717139/147837887-308591d5-47ba-435e-903e-8b245def0a84.jpeg)

![IMG_9C967D1A90FD-1](https://user-images.githubusercontent.com/70717139/147837835-c8090601-8134-42eb-acd3-463968d7a4d1.jpeg) ![IMG_72EF15491E30-1](https://user-images.githubusercontent.com/70717139/147837825-ce3c8894-f68c-4a08-94a8-38f3d5586fea.jpeg)  


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
