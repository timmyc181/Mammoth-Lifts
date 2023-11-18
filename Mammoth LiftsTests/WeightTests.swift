import XCTest

final class WeightTests: XCTestCase {
    var weight: Weight = 108.25

    override func setUpWithError() throws {
        weight = 108.25
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTextInitializer() throws {
        let weightFromText = Weight("108.25")
        
        XCTAssertEqual(weightFromText, weight)
    }

    func testTextGetter() throws {
        XCTAssertEqual(weight.text, "108.25")
    }

    func testPlusEquals() throws {
        weight += Weight(5.25)
        XCTAssertEqual(weight, 113.5)
    }
    func testPlus() throws {
        XCTAssertEqual(weight + 5.25, 113.5)
    }
    func testMinusEquals() throws {
        weight -= 5.25
        XCTAssertEqual(weight, 103)
    }
    func testMinus() throws {
        XCTAssertEqual(weight - 5.25, 103)
    }

    func testLessThanExpectsTrue() {
        XCTAssert(weight < 108.75)
    }
    
    
}
