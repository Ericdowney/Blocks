
import XCTest
@testable import BlockLogic

final class BlockStatefulFlowTests: XCTestCase {
    
    func test_run_whenTypesMatch_shouldOutputTheCorrectResult() throws {
        let subject = BlockStatefulFlow<TestState, Int, Int>(
            state: TestState(),
            sequence: Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock()
        )
        
        try subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, 18)
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenSequenceIsEmpty_shouldThrowError() {
        let subject: BlockStatelessFlow<Int, Int> = BlockStatelessFlow(sequence: .init())
        
        do {
            try subject.run(2) { _ in XCTFail() }
        } catch {
            XCTAssertEqual(error as? BlockError, .emptyBlockSequence)
        }
    }
    
    func test_run_whenOutputTypesDoNotMatch_shouldThrowError() throws {
        let subject: BlockStatelessFlow<Int, String> = BlockStatelessFlow(
            sequence: .init() --> Add4Block() --> Add4Block() --> Add4Block() --> Add4Block()
        )
        
        do {
            try subject.run(2) { _ in XCTFail() }
        } catch {
            XCTAssertEqual(error as? BlockError, .unmatchedOutputTypes)
        }
    }
    
    func test_run_whenInputTypesDoNotMatch_shouldThrowError() throws {
        let subject: BlockStatelessFlow<Int, Int> = BlockStatelessFlow(
            sequence: .init() --> Add4Block() --> StringToIntBlock() --> Add4Block() --> Add4Block()
        )
        
        do {
            try subject.run(2) { _ in XCTFail() }
        } catch {
            XCTAssertEqual(error as? BlockError, .unmatchedInputTypes)
        }
    }
}
