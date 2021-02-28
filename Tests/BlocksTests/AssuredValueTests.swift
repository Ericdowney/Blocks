
import XCTest
import Blocks

final class AssuredValueTests: XCTestCase {
    
    // MARK: - Tests
    
    func test_whenValueExists_shouldCreateAssuredValue() {
        let subject = AssuredValue(3)
        
        XCTAssertNotNil(subject.wrappedValue)
        XCTAssertEqual(subject.wrappedValue, 3)
        XCTAssertEqual(subject.description, "AssuredValue<Int>: 3")
    }
    
    func test_whenValueDoesNotExist_shouldCreateAssuredValue() {
        let subject = AssuredValue<Int>()
        
        XCTAssertNil(subject.wrappedValue)
        XCTAssertEqual(subject.description, "AssuredValue<Int>: nil")
    }
    
    // MARK: - Test Registration
    
    static var allTests = [
        ("test_whenValueExists_shouldCreateAssuredValue", test_whenValueExists_shouldCreateAssuredValue),
        ("test_whenValueDoesNotExist_shouldCreateAssuredValue", test_whenValueDoesNotExist_shouldCreateAssuredValue),
    ]
}
