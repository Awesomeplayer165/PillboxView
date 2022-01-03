# PillboxView

Pillbox View shows a small bubble, pill looking box that sides from the top of the screen. You most likely have seen this throughout iOS when the ringer state is changed, Airpods are connected and when you copy your Discord ID, among others. 

> Note: Discord did not use this, they were my inspiration for creating this since I could not find a dependency that did this

![IMG_A7E525EB0B26-1](https://user-images.githubusercontent.com/70717139/147837921-c4a14eae-843c-4483-959c-d13cea3458e2.png)

## Installation

PillboxView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PillboxView'
```

## Example

- Display a title message
- Show an activity indicator to show ongoing activity ![IMG_439D92B0A93B-1](https://user-images.githubusercontent.com/70717139/147837941-3ebd4ed7-b547-4601-87f5-dec0c7d5f317.jpeg)

  - Indicate your task's success with a green checkmark ![IMG_9C967D1A90FD-1](https://user-images.githubusercontent.com/70717139/147837835-c8090601-8134-42eb-acd3-463968d7a4d1.jpeg) 
 or failure with a red x ![IMG_72EF15491E30-1](https://user-images.githubusercontent.com/70717139/147837825-ce3c8894-f68c-4a08-94a8-38f3d5586fea.jpeg)
- Animates between images and frames for clean effect
=======
To run the example project, clone the repo, and run `pod install` from the Example directory first.

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


## Requirements

iOS 13.0 or higher

## License

PillboxView is available under the MIT license. See the LICENSE file for more info.
