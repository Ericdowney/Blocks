
import XCTest
import Blocks

final class CombineTests: XCTestCase {
    struct SequenceBlock: Block {
        func run(_ input: Void, _ context: BlockContext) async throws -> [Int] {
            [1,2,3]
        }
    }
    struct TestGroup1: BlockGroup {
        typealias Input = Void
        typealias Output = [Int]
        
        var set: BlockSet<Void, [Int]> {
            Combine(block1: SequenceBlock(), block2: SequenceBlock())
        }
    }
    
    func test_combine_shouldReturnCorrectResult() async throws {
        let result = try await TestGroup1().run()
        
        XCTAssertEqual(result, [1,2,3,1,2,3])
    }
}
