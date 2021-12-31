# Template

Small Summary about the repository and its purpose

## About:

Go into more detail about the repository and its purpose

## Features:

### Integer From String 

If a variable read from the console is an integer, then return true:

```swift

func checkIfStringContainsInteger(with string: String) -> Bool {
  if let string = Int(string) {
    return true
  }
  
  return false
}

if let readLine = readLine() {
  print(checkIfStringContainsInteger(with: readLine))
}

```

But we can improve this code by extending String to get `self` as the String type presented

```swift

extension String {
  func checkIfStringContainsInteger() -> Bool {
    if let self = Int(self) { return true }
    
    return false
  }
}

if let readLine = readLine() {
  print(checkIfStringContainsInteger(with: readLine))
}

```

### Conclusion:

Write a small conclusion for your repository

## Created and Maintained by:

[Jacob Trentini](https://github.com/Awesomeplayer165)
