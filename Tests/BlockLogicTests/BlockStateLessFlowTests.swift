import XCTest
@testable import BlockLogic

final class BlockStateLessFlowTests: XCTestCase {
        
    func test_run_whenTypesMatch_shouldOutputTheCorrectResult() throws {
        let subject: BlockStatelessFlow<Int, Int> = BlockStatelessFlow(
            sequence: Add4Block() --> Add4Block() --> Add4Block() --> Add4Block()
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
    
    func test_run_whenMultipleSequencesAreConnected_shouldOutputTheCorrectResult() throws {
        let sequence1: BlockSequence<Int, Int> = Add4Block() --> Add4Block() --> Add4Block() --> Add4Block()
        let sequence2: BlockSequence<Int, Int> = Add4Block() --> Add4Block()
        let subject: BlockStatelessFlow<Int, Int> = BlockStatelessFlow(
            sequence: sequence1 --> sequence2
        )
        
        try subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, 26)
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenMultipleTypeBlocksExist_shouldOutputTheCorrectResult() throws {
        let subject: BlockStatelessFlow<Int, String> = BlockStatelessFlow(
            sequence: Add4Block() --> Add4Block() --> Add4Block() --> Add4Block() --> IntToStringBlock() --> ConcatenateStringBlock()
        )
        
        try subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, "18-123")
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenSequenceFails_shouldFailWithError() throws {
        let subject: BlockStatelessFlow<Int, Int> = BlockStatelessFlow(
            sequence: Add4Block() --> Add4Block() --> Add4Block() --> Add4Block() --> IntFailWithErrorBlock()
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
        let subject: BlockStatelessFlow<Int, Int> = BlockStatelessFlow(
            sequence: Add4Block() --> Add4Block() --> Add4Block() --> Add4Block() --> IntFailWithErrorBlock()
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
        let subject: BlockStatelessFlow<Int, Int> = BlockStatelessFlow(sequence: .init())
        
        do {
            try subject.run(2) { _ in XCTFail() }
        } catch {
            XCTAssertEqual(error as? BlockError, .emptyBlockSequence)
        }
    }
    
    func test_run_whenOutputTypesDoNotMatch_shouldThrowError() throws {
        let subject: BlockStatelessFlow<Int, String> = BlockStatelessFlow(
            sequence: Add4Block() --> Add4Block() --> Add4Block() --> Add4Block()
        )
        
        do {
            try subject.run(2) { _ in XCTFail() }
        } catch {
            XCTAssertEqual(error as? BlockError, .unmatchedOutputTypes)
        }
    }
    
    func test_run_whenInputTypesDoNotMatch_shouldThrowError() throws {
        let subject: BlockStatelessFlow<Int, Int> = BlockStatelessFlow(
            sequence: [Add4Block().eraseToAnyBlock(), StringToIntBlock().eraseToAnyBlock(), Add4Block().eraseToAnyBlock(), Add4Block().eraseToAnyBlock()]
        )
        
        do {
            try subject.run(2) { _ in XCTFail() }
        } catch {
            XCTAssertEqual(error as? BlockError, .unmatchedInputTypes)
        }
    }
}
