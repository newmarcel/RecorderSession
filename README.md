<img src="https://raw.githubusercontent.com/newmarcel/RecorderSession/master/Icon%402x.png" width="64" height="64" />

# RecorderSession

[Docs](https://newmarcel.github.io/RecorderSession/index.html) | [Downloads](https://github.com/newmarcel/RecorderSession/releases)

An `NSURLSession` test framework for iOS and macOS inspired by [DVR](https://github.com/venmo/DVR) and [VCR](https://github.com/vcr/vcr) _(that's where the cassette metaphor comes from…)_.

It's not as mature as [DVR](https://github.com/venmo/DVR) yet, but there are some advantages:

- cassettes are stored in a `Cassettes.bundle` folder and don't pollute your Xcode project file
- customizable options for matching the original request with the cassette, e.g. the host component can be ignored
- it's tiny: 700 KB (vs. DVR: 3.4 MB)
- no Swift dependency, but it works great with Swift
    - in fact Objective-C support was the primary motivation for creating this framework

## Usage

To allow `NSURLSession` testing, please make sure your API client's session can be either switched out or added in via dependency injection in the initializer.

Your test target should contain a `Cassettes.bundle` folder where all the recorded cassettes are stored.

```swift
import RecorderSession

let bundle = Bundle(for: type(of: self)).cassetteBundle

// Switch your URLSession with RecorderSession.
// The original URLSession will be used for recording cassettes.
let recorderSession = RCNRecorderSession(backingSession: originalURLSession, cassetteBundle: bundle)
let client = MyAPIClient(session: recorderSession)

// Load a cassette to record or replay
recorderSession.insertCassette(name: "GetItems")

// Perform your network request
client.getItems { items, error in
    XCTAssertNotNil(items)
    XCTAssertNil(error)

    expectation.fulfill()
}
```

When you run the test for the first time, the cassette will be persisted to disk and the executation will halt. You need to move the cassette file from the printed location to your cassette bundle. All subsequent test runs will use the cassette instead.

## Installation via Carthage

Carthage is the preferred, but not the only way of installing `RecorderSession` into your project. Add the following line to your Cartfile and run `carthage update`:

```
github "newmarcel/RecorderSession"
```

## Naming

- **"Cassette"**: A JSON file representing an HTTP request, response and body.
- **"recording a cassette"**: Making a live HTTP request and save the request, response and payload to disk.
- **"playing a cassette"**: Simulating a live HTTP request, response and body with the saved JSON _"cassette"_ from disk.

## License

[MIT](./LICENSE)
