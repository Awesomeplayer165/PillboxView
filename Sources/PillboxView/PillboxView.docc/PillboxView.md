# ``PillboxView``

A small pill that presents a view on an asynchronous on-going task, the state of an asynchronous task, or instant task

PillboxView shows a small bubble, pill looking rounded box that slides in from the top of the screen. You most likely have seen this throughout iOS when the ringer state is changed, Airpods are connected and when you copy your Discord ID, among others. This provides users with assurance that things are happening behind the works and helps bring safely reporting background proccesses to the main UI. 

![An example of ``PillboxView/PillView`` waiting for an asynchronous task to finish.](showTaskSpinning)
![An example of ``PillboxView/PillView`` reporting success for an asynchronous task that it waited to finish.](showTaskCompletedWithSuccess)
![An example of ``PillboxView/PillView`` reporting failure for an asynchronous task that it waited to finish.](showTaskCompletedWithFailure)


## Topics

### Essentials
- ``PillboxView/PillView``
- ``PillboxView/PillShowType``

### Asynchronous Tasking
- ``PillboxView/PillView/showTask(message:vcView:)``
- ``PillboxView/PillView/completedTask(state:completionHandler:)``

### Instant Erring
- ``PillboxView/PillView/showError(message:vcView:)``

### Visual Transitions
- ``PillboxView/PillView/reveal(animated:completionHandler:)``
- ``PillboxView/PillView/dismiss(animated:completionHandler:)``
