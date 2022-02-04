# PillboxView

Pillbox View shows a small bubble, pill looking box that sides from the top of the screen. You most likely have seen this throughout iOS when the ringer state is changed, Airpods are connected and when you copy your Discord ID, among others. 

> Note: Discord does not use this dependency, they were my inspiration for creating this since I could not find a dependency that did this


## Installation

PillboxView is available through [Swift Package Manager](https://www.swift.org/package-manager).

## Example

- Display a title message
- Show an activity indicator to show ongoing activity ![IMG_439D92B0A93B-1](https://user-images.githubusercontent.com/70717139/147837941-3ebd4ed7-b547-4601-87f5-dec0c7d5f317.jpeg)

- Indicate your task's success with a green checkmark ![IMG_9C967D1A90FD-1](https://user-images.githubusercontent.com/70717139/147837835-c8090601-8134-42eb-acd3-463968d7a4d1.jpeg) 
 or failure with a red x ![IMG_72EF15491E30-1](https://user-images.githubusercontent.com/70717139/147837825-ce3c8894-f68c-4a08-94a8-38f3d5586fea.jpeg)
- Animates between images and frames for clean effect

## Quick Start

### Asynchronous Task

This is great for network calls to assure the user that there is something going on.

All you have to do is pass in a title message and your `UIViewController`'s `UIView`

```swift

import UIKit
import PillboxView

class ViewController: UIViewController {

    let pill = PillView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pill.show(title: "Refreshing Data", vcView: self.view)
        
        // some time later...
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          pill.completedTask(state: true) // this indicates the task's success
        }
    }
}

```

### Error

This is especially useful if you want to display a concise error message, and the task's completion time is very quick (like checking the values of a `UITextField` and reporting if any are invalid.) 

```swift

import UIKit
import PillboxView

class ViewController: UIViewController {

    let pill = PillView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pill.showError(message: "Refreshing Data", vcView: self.view)
    }
}

```

## Conclusion

Let me know how this is and help me improve this project with ideas, suggestions.


## Requirements

iOS 13.0 or higher

## License

PillboxView is available under the MIT license. See the LICENSE file for more info.
