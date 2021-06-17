
import XCTest
@testable import Blocks

final class BlockTests: XCTestCase {
    struct TestGroup1: BlockGroup {
        typealias Input = Int
        typealias Output = Int
        
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
        typealias Input = Int
        typealias Output = String
        
        var state: CustomState = .init()
        var set: BlockSet<Int, String> {
            AddFour()
            AddStateValue()
            IntToString()
        }
    }
    struct TestGroup3: BlockGroup {
        typealias Input = Int
        typealias Output = String
        
        var state: CustomState = .init()
        var set: BlockSet<Int, String> {
            TestGroup1(value: true)
            TestGroup2()
        }
    }
    struct TestGroup4: BlockGroup {
        typealias Input = Int
        typealias Output = String
        
        var state: CustomState = .init()
        var set: BlockSet<Int, String> {
            TestGroup1(value: true)
            TestGroup1(value: false)
            AddFive()
            TestGroup2()
        }
    }
    
    func test_testGroup1_whenValueIsTrue_shouldReturnCorrectResult() async throws {
        let subject = TestGroup1(value: true)
        
        let result = try await subject(input: 1)
        XCTAssertEqual(result, 7)
    }
    
    func test_testGroup1_whenValueIsFalse_shouldReturnCorrectResult() async throws {
        let subject = TestGroup1(value: false)
        
        let result = try await subject(input: 1)
        XCTAssertEqual(result, 8)
    }
    
    func test_testGroup2_shouldReturnCorrectResult() async throws {
        let subject = TestGroup2()
        
        let result = try await subject(input: 3)
        XCTAssertEqual(result, "9")
    }
    
    func test_testGroup3_shouldReturnCorrectResult() async throws {
        let subject = TestGroup3()
        
        let result = try await subject(input: 3)
        XCTAssertEqual(result, "15")
    }
    
    func test_testGroup4_shouldReturnCorrectResult() async throws {
        let subject = TestGroup4()
        
        let result = try await subject(input: 3)
        XCTAssertEqual(result, "27")
    }
}
