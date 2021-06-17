
import XCTest
import Blocks

final class ConcurrentTests: XCTestCase {
    struct TestGroup1: BlockGroup {
        typealias Input = Int
        typealias Output = Int?
        
        var set: BlockSet<Int, Int?> {
            Concurrent(AddOne(), AddTwo())
            Transform { (input: (Int, Int)) in
                input.0 + input.1
            }
        }
    }
    
    func test_shouldReturnTheCorrectValue() async throws {
        let result = try await TestGroup1().run(3)
        
        XCTAssertEqual(result, 9)
    }
}
