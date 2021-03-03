import XCTest
@testable import Blocks

final class BlockStateLessFlowTests: XCTestCase {
    
    // MARK: - Tests
        
    func test_run_whenTypesMatch_shouldOutputTheCorrectResult() throws {
        let subject = BlockStatelessFlow(
            sequence: Add4Block() --> Add4Block() --> Add4Block() --> Add4Block()
        )
        
        try subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, 18)
            case .break(_):
                XCTFail()
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenMultipleSequencesAreConnected_shouldOutputTheCorrectResult() throws {
        let sequence1 = Add4Block() --> Add4Block() --> Add4Block() --> Add4Block()
        let sequence2 = Add4Block() --> Add4Block()
        let subject = BlockStatelessFlow(
            sequence: sequence1 --> sequence2
        )
        
        try subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, 26)
            case .break(_):
                XCTFail()
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenMultipleTypeBlocksExist_shouldOutputTheCorrectResult() throws {
        let subject = BlockStatelessFlow(
            sequence: Add4Block() --> Add4Block() --> Add4Block() --> Add4Block() --> IntToStringBlock() --> ConcatenateStringBlock()
        )
        
        try subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, "18-123")
            case .break(_):
                XCTFail()
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenBlockBreaksEarly_sholdOutputCorrectResult() throws {
        let subject = BlockStatelessFlow(
            sequence: Add4Block() --> StringBreakBlock() --> ConcatenateStringBlock()
        )
        
        try subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, "6-END")
            case .break(_):
                XCTFail()
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenBlockBreaksEarlyInInnerSequence_sholdOutputCorrectResult() throws {
        let sequence1 = Add4Block() --> Add4Block()
        let sequence2 = StringBreakBlock() --> ConcatenateStringBlock() --> ConcatenateStringBlock() --> ConcatenateStringBlock()
        let sequence3 = ConcatenateStringBlock() --> ConcatenateStringBlock()
        let subject = BlockStatelessFlow(
            sequence: sequence1 --> sequence2 --> sequence3
        )
        
        try subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, "10-END-123-123")
            case .break(_):
                XCTFail()
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenBlockHaveVoidInput_sholdOutputCorrectResult() throws {
        let subject = BlockStatelessFlow(
            sequence: Add4Block() --> Add4Block() --> Add4Block() --> VoidInputIntOutputBlock()
        )
        
        try subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, 39)
            case .break(_):
                XCTFail()
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenSequenceFails_shouldFailWithError() throws {
        let subject = BlockStatelessFlow(
            sequence: Add4Block() --> Add4Block() --> Add4Block() --> Add4Block() --> IntFailWithErrorBlock()
        )
        
        try subject.run(2) { result in
            switch result {
            case .done(_):
                XCTFail()
            case .break(_):
                XCTFail()
            case .failed(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func test_run_whenSequenceFails_shouldFailWithoutError() throws {
        let subject = BlockStatelessFlow(
            sequence: Add4Block() --> Add4Block() --> Add4Block() --> Add4Block() --> IntFailWithErrorBlock()
        )
        
        try subject.run(2) { result in
            switch result {
            case .done(_):
                XCTFail()
            case .break(_):
                XCTFail()
            case .failed(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func test_run_whenSequenceIsEmpty_shouldThrowError() {
        let subject = BlockStatelessFlow<Int, Int>(sequence: .init())
        
        do {
            try subject.run(2) { _ in XCTFail() }
        } catch {
            XCTAssertEqual(error as? BlockError, .emptyBlockSequence)
        }
    }
    
    func test_run_whenOutputTypesDoNotMatch_shouldThrowError() throws {
        let subject = BlockStatelessFlow<Int, String>(
            sequence: [Add4Block().eraseToAnyBlock(), Add4Block().eraseToAnyBlock(), Add4Block().eraseToAnyBlock(), Add4Block().eraseToAnyBlock()]
        )
        
        do {
            try subject.run(2) { _ in XCTFail() }
        } catch {
            XCTAssertEqual(error as? BlockError, .unmatchedOutputTypes)
        }
    }
    
    func test_run_whenInputTypesDoNotMatch_shouldThrowError() throws {
        let subject = BlockStatelessFlow<Int, Int>(
            sequence: [Add4Block().eraseToAnyBlock(), StringToIntBlock().eraseToAnyBlock(), Add4Block().eraseToAnyBlock(), Add4Block().eraseToAnyBlock()]
        )
        
        do {
            try subject.run(2) { _ in XCTFail() }
        } catch {
            XCTAssertEqual(error as? BlockError, .unmatchedInputTypes)
        }
    }
    
    // MARK: - Test Registration
    
    static var allTests = [
        ("test_run_whenTypesMatch_shouldOutputTheCorrectResult", test_run_whenTypesMatch_shouldOutputTheCorrectResult),
        ("test_run_whenMultipleSequencesAreConnected_shouldOutputTheCorrectResult", test_run_whenMultipleSequencesAreConnected_shouldOutputTheCorrectResult),
        ("test_run_whenMultipleTypeBlocksExist_shouldOutputTheCorrectResult", test_run_whenMultipleTypeBlocksExist_shouldOutputTheCorrectResult),
        ("test_run_whenBlockBreaksEarly_sholdOutputCorrectResult", test_run_whenBlockBreaksEarly_sholdOutputCorrectResult),
        ("test_run_whenBlockBreaksEarlyInInnerSequence_sholdOutputCorrectResult", test_run_whenBlockBreaksEarlyInInnerSequence_sholdOutputCorrectResult),
        ("test_run_whenSequenceFails_shouldFailWithError", test_run_whenSequenceFails_shouldFailWithError),
        ("test_run_whenSequenceFails_shouldFailWithoutError", test_run_whenSequenceFails_shouldFailWithoutError),
        ("test_run_whenSequenceIsEmpty_shouldThrowError", test_run_whenSequenceIsEmpty_shouldThrowError),
        ("test_run_whenOutputTypesDoNotMatch_shouldThrowError", test_run_whenOutputTypesDoNotMatch_shouldThrowError),
        ("test_run_whenInputTypesDoNotMatch_shouldThrowError", test_run_whenInputTypesDoNotMatch_shouldThrowError),
    ]
}
