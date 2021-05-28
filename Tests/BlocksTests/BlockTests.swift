
import XCTest
@testable import Blocks

final class BlockTests: XCTestCase {
    struct TestGroup1: BlockGroup {
        var value: Bool
        var state: CustomState = .init()
        var set: BlockSet<Int, Int> {
            AddOne()
            AddTwo()
            if value {
                AddThree()
            }
            else {
                AddFour()
            }
        }
    }
    struct TestGroup2: BlockGroup {
        var state: CustomState = .init()
        var set: BlockSet<Int, String> {
            AddFour()
            AddFour()
            AddStateValue()
            IntToString()
        }
    }
    struct TestGroup3: BlockGroup {
        var state: CustomState = .init()
        var set: BlockSet<Int, String> {
            TestGroup1(value: true)
            TestGroup2()
        }
    }
    
    func test_testGroup1_whenValueIsTrue_shouldReturnCorrectResult() {
        let subject = TestGroup1(value: true)
        
        subject(input: 1) { result in
            switch result {
            case .break(_): XCTFail()
            case .done(let value): XCTAssertEqual(value, 7)
            case .failed(_): XCTFail()
            }
        }
    }
    
    func test_testGroup1_whenValueIsFalse_shouldReturnCorrectResult() {
        let subject = TestGroup1(value: false)
        
        subject(input: 1) { result in
            switch result {
            case .break(_): XCTFail()
            case .done(let value): XCTAssertEqual(value, 8)
            case .failed(_): XCTFail()
            }
        }
    }
    
    func test_testGroup2_shouldReturnCorrectResult() {
        let subject = TestGroup2()
        
        subject(input: 3) { result in
            switch result {
            case .break(_): XCTFail()
            case .done(let value): XCTAssertEqual(value, "9")
            case .failed(_): XCTFail()
            }
        }
    }
    
    func test_testGroup3_shouldReturnCorrectResult() {
        let subject = TestGroup3()
        
        subject(input: 3) { result in
            switch result {
            case .break(_): XCTFail()
            case .done(let value): XCTAssertEqual(value, "15")
            case .failed(_): XCTFail()
            }
        }
    }
}
