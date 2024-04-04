Survey App
This Survey App allows users to participate in a survey by answering a series of questions. It consists of two screens, an initial onboarding screen and a questions screen where users can navigate through and answer survey questions.

Features
- Start survey button on the initial screen loads the questions screen.
- Questions screen displays a horizontal pager of all survey questions.
- Previous and next buttons allow users to navigate between questions.
- Previous button is disabled on the first question and next button is disabled on the last question.
- Submit button posts the user's answers to the server.
- Submit button is disabled when no answer text exists or when the question has already been answered.
- Counter of already submitted questions is displayed on top of each question and is updated dynamically after every successful question submission.
- Success and failure notifications are displayed for successful and failed question submissions, respectively.
- Successful question submissions are kept in memory so that when navigating to an already submitted question, the submitted answer will be present and the submit button will be disabled.
- Once the user submits answers for all questions, a confirmation pop-up will prompt, followed by redirection to the initial screen.

Implementation details
- This app is implemented using Swift.
- It follows a unidirectional data flow style, specifically using the SwiftUI framework.
- The Combine framework is used for handling asynchronous events and data streams.
- SwiftUI's declarative syntax is leveraged for building user interfaces, making it easy to compose complex views and manage state.
- Unit tests are provided to ensure the correctness of the app's logic and behavior.

I crafted this sample app leveraging Xcode 15 and Swift 5.0. Throughout this assignment, I integrated various technologies and programming concepts, such as:
- MVVM architecture
- Fundamental data structures
- Server communication using URLSession
- JSON parsing and decodable
- Reactive programming using Combine
- Loaders implementation
- Unit testing with session mocking techniques
- UI testing
- Snapshots testing
- Gernerics functions
- Error handing
- Dark and light theme
- Localizable strings for app internationalization
- Dependency management using Swift Package Manager (SPM)
- GitHub for efficient version control
