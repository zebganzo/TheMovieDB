The evaluation criteria mentioned in the are assignment what I always aim for when I code. With this project, I've tried to give an idea of how I usually work, even if there are many things that I'd have done and improved with more time.

From a "feature-screen point of view", the architecture follows the MVVM pattern: for each screen there a UIViewController that owns the view and the view model. The latter implements the business logic and exposes methods and variables for the interaction with the view controller.

The initialization of the view controller, and its view model, and the actual decision of which one has to be shown are responsibilities of the duo "presenter manager + routing manager". These two components are the two faces of the same medal, the routing manager is in charge of creating a view model starting from the previous view model and its output, while the presenter manager creates the corresponding view controller and makes sure that it's shown to the user.
It may be easier to think about it as a finite-state machine: for a given state (current view model) and an input (the output of the current view model), generates a new state (the view model and the necessary view controller).
This type of approach, which is quite simple/dummy in my quick implementation, makes the navigation of the app prone to tests.

From another perspective, in my opinion, the code is testable thanks to the extensive use of protocols. Using protocols, it's easier to create mocks and stubs.

The requests to the backend are performed by a "low level" HTTP layer, with a very basic implementation on top of URLSession. This layer is then used by the ApiClient for exposing the methods to the codebase. In a similar way, the StoraClient uses UserDefaults for storing the suggestions but hiding the implementation with a protocol. In this way, it's easy to change the technology for storage.

The codebase of the MVVM pattern makes an extensive use of ReactiveSwift and ReactiveCocoa. The constraints of the view are built with SnapKit. The loading and the caching of the images are implemented by SDWebImage. I think that Quick and Nimble are very good libraries for the creation of the tests.

The last instruction of the assignment says "You should submit code that you would be ​happy​ ​to​ ​produce". As mentioned, there are many things that I'd improve in my project, but for sure the first one is its code coverage. I usually prefer to have a TDD approach, but it was hard to have it with the given time.
