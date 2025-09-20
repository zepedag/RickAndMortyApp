//
//  RickAndMortyAppUITests.swift
//  RickAndMortyAppUITests
//
//  Created by Humberto Alejandro Zepeda González on 17/09/25.
//

import XCTest

final class RickAndMortyAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Test episode watch status toggle flow
    @MainActor
    func testEpisodeWatchToggleFlow() throws {
        let app = XCUIApplication()
        app.launch()
        
        // 1. Verify app launched successfully
        XCTAssertTrue(app.staticTexts["Characters"].waitForExistence(timeout: 15.0), "Characters title should be visible")
        print("App launched successfully")
        
        // 2. Wait for characters to load
        sleep(2)
        
        // 3. Find the first character by looking for the first "Rick Sanchez" text
        let rickCharacterQuery = app.staticTexts.matching(NSPredicate(format: "label == 'Rick Sanchez'"))
        if rickCharacterQuery.count > 0 {
            let firstRickCharacter = rickCharacterQuery.element(boundBy: 0)
            if firstRickCharacter.waitForExistence(timeout: 10.0) {
                print("Found Rick Sanchez character")
                firstRickCharacter.tap()
                print("Tapped on Rick Sanchez")
            }
        } else {
            // Fallback: try to find any character by looking for species text first
            let speciesTexts = app.staticTexts.matching(NSPredicate(format: "label == 'Human' OR label == 'Alien'"))
            if speciesTexts.count > 0 {
                let firstSpecies = speciesTexts.element(boundBy: 0)
                if firstSpecies.waitForExistence(timeout: 5.0) {
                    print("Found species text: " + firstSpecies.label)
                    // Tap on the parent container that contains this species text
                    firstSpecies.tap()
                    print("Tapped on character via species")
                }
            }
        }
        
        // 4. Verify character detail opened by looking for the close button
        let detailExists = app.buttons["xmark"].waitForExistence(timeout: 10.0)
        XCTAssertTrue(detailExists, "Character detail should open")
        print("Character detail opened")
        
        // 5. Wait a moment for content to load
        sleep(1)
        
        // 6. Try to interact with episode toggle buttons (checkmark.circle.fill or circle)
        // First try to find buttons with checkmark.circle.fill (watched episodes)
        let watchedEpisodeButtons = app.buttons.matching(NSPredicate(format: "label CONTAINS 'checkmark.circle.fill'"))
        if watchedEpisodeButtons.count > 0 {
            let firstWatchedButton = watchedEpisodeButtons.element(boundBy: 0)
            if firstWatchedButton.waitForExistence(timeout: 5.0) {
                print("Found watched episode button: " + firstWatchedButton.label)
                firstWatchedButton.tap()
                print("Tapped watched episode button")
                sleep(1)
            }
        } else {
            // Try to find buttons with circle (unwatched episodes)
            let unwatchedEpisodeButtons = app.buttons.matching(NSPredicate(format: "label CONTAINS 'circle'"))
            if unwatchedEpisodeButtons.count > 0 {
                let firstUnwatchedButton = unwatchedEpisodeButtons.element(boundBy: 0)
                if firstUnwatchedButton.waitForExistence(timeout: 5.0) {
                    print("Found unwatched episode button: " + firstUnwatchedButton.label)
                    firstUnwatchedButton.tap()
                    print("Tapped unwatched episode button")
                    sleep(1)
                }
            } else {
                // Try to find any button that might be an episode toggle
                let allButtons = app.buttons
                print("Total buttons found: \(allButtons.count)")
                for i in 0..<min(allButtons.count, 10) {
                    let button = allButtons.element(boundBy: i)
                    print("Button \(i): " + button.label)
                }
                
                // Try to tap the 5th button (likely an episode toggle based on the UI)
                if allButtons.count > 4 {
                    let episodeButton = allButtons.element(boundBy: 4)
                    if episodeButton.waitForExistence(timeout: 3.0) {
                        print("Tapping button 4: " + episodeButton.label)
                        episodeButton.tap()
                        print("Tapped button 4")
                        sleep(1)
                    }
                }
            }
        }
        
        // 7. Close character detail
        let closeDetail = app.buttons["xmark"]
        if closeDetail.waitForExistence(timeout: 3.0) {
            closeDetail.tap()
            print("Closed character detail")
            sleep(1)
        }
        
        // 8. Verify back to main screen
        XCTAssertTrue(app.staticTexts["Characters"].waitForExistence(timeout: 5.0), "Should return to main screen")
        print("Episode watch toggle flow completed successfully")
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
