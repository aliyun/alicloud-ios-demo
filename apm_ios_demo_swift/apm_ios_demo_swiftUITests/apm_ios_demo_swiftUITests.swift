import XCTest

final class apm_ios_demo_swiftUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testSettingsSaveAndReturnToHome() throws {
        let app = XCUIApplication()
        app.launch()

        let settingsButton = app.buttons["home.settings"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 2))
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.975, dy: 0.092)).tap()

        let userIdField = app.textFields["settings.userId"]
        XCTAssertTrue(userIdField.waitForExistence(timeout: 2))
        userIdField.tap()
        userIdField.typeText("demo-user")

        let saveButton = app.buttons["settings.save"]
        XCTAssertTrue(saveButton.exists)
        saveButton.tap()
    }

    func testInvalidNetworkURLShowsFeedback() throws {
        let app = XCUIApplication()
        app.launch()

        let networkButton = app.buttons["home.card.networkAnalysis"]
        XCTAssertTrue(waitForElement(networkButton, in: app))
        networkButton.tap()

        let urlField = app.textFields["network.url"]
        XCTAssertTrue(urlField.waitForExistence(timeout: 2))
        urlField.tap()
        urlField.typeText("invalid")

        app.buttons["network.send"].tap()

        let alertTitle = app.staticTexts["overlay.alert.title"]
        let alertMessage = app.staticTexts["overlay.alert.message"]
        XCTAssertTrue(alertTitle.waitForExistence(timeout: 2))
        XCTAssertEqual(alertTitle.label, "提示")
        XCTAssertTrue(alertMessage.label.contains("请输入有效的完整 HTTP(S) URL"))
    }

    func testPageAnalysisMatchesObjectiveCDemoContent() throws {
        let app = XCUIApplication()
        app.launch()

        let pageAnalysisButton = app.buttons["home.card.pageAnalysis"]
        XCTAssertTrue(waitForElement(pageAnalysisButton, in: app))
        pageAnalysisButton.tap()

        XCTAssertTrue(app.staticTexts["页面分析"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["请滑动页面。页面分析数据在App退至后台时统一上报，稍后可在 EMAS 控制台查看。"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["阿里云EMAS"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["APM 性能监控"].waitForExistence(timeout: 2))
    }

    private func waitForElement(_ element: XCUIElement, in app: XCUIApplication, maxSwipes: Int = 6) -> Bool {
        if element.waitForExistence(timeout: 2), element.isHittable {
            return true
        }

        for _ in 0..<maxSwipes {
            app.swipeUp()
            if element.waitForExistence(timeout: 1), element.isHittable {
                return true
            }
        }

        return element.exists
    }
}
