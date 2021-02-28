
import XCTest
@testable import BlockLogic

final class BlockStatefulFlowTests: XCTestCase {
    
    func test_run_whenTypesMatch_shouldOutputTheCorrectResult() throws {
        let subject = BlockStatefulFlow<TestState, Int, Int>(
            state: .init(),
            sequence: Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock()
        )
        
        try subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, 92)
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenMixingStatefulAndStatelessBlocks_shouldOutputTheCorrectResult() throws {
        let subject = BlockStatefulFlow<TestState, Int, Int>(
            state: .init(),
            sequence: Add4Block() --> Add4StateBlock() --> Add4StateBlock() --> Add4Block() --> Add4StateBlock() --> Add4StateBlock() --> Add4Block()
        )
        
        try subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, 176)
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenSequenceFails_shouldFailWithError() throws {
        let subject: BlockStatefulFlow<TestState, Int, Int> = BlockStatefulFlow(
            state: .init(),
            sequence: Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock() --> IntFailWithErrorStateBlock()
        )
        
        try subject.run(2) { result in
            switch result {
            case .done(_):
                XCTFail()
            case .failed(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func test_run_whenSequenceFails_shouldFailWithoutError() throws {
        let subject: BlockStatefulFlow<TestState, Int, Int> = BlockStatefulFlow(
            state: .init(),
            sequence: Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock() --> IntFailWithErrorStateBlock()
        )
        
        try subject.run(2) { result in
            switch result {
            case .done(_):
                XCTFail()
            case .failed(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func test_run_whenSequenceIsEmpty_shouldThrowError() {
        let subject: BlockStatefulFlow<TestState, Int, Int> = BlockStatefulFlow(
            state: .init(),
            sequence: .init()
        )
        
        do {
            try subject.run(2) { _ in XCTFail() }
        } catch {
            XCTAssertEqual(error as? BlockError, .emptyBlockSequence)
        }
    }
    
    func test_run_whenOutputTypesDoNotMatch_shouldThrowError() throws {
        let subject: BlockStatefulFlow<TestState, Int, String> = BlockStatefulFlow(
            state: .init(),
            sequence: Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock()
        )
        
        do {
            try subject.run(2) { _ in XCTFail() }
        } catch {
            XCTAssertEqual(error as? BlockError, .unmatchedOutputTypes)
        }
    }
    
    func test_run_whenInputTypesDoNotMatch_shouldThrowError() throws {
        let subject: BlockStatefulFlow<TestState, Int, Int> = BlockStatefulFlow(
            state: .init(),
            sequence: .init() --> Add4StateBlock() --> StringToIntStateBlock() --> Add4StateBlock() --> Add4StateBlock()
        )
        
        do {
            try subject.run(2) { _ in XCTFail() }
        } catch {
            XCTAssertEqual(error as? BlockError, .unmatchedInputTypes)
        }
    }
}
