
import XCTest
@testable import Blocks

final class BlockStatefulFlowTests: XCTestCase {
    
    // MARK: - Tests
    
    func test_run_whenTypesMatch_shouldOutputTheCorrectResult() throws {
        let subject = BlockStatefulFlow(
            state: .init(),
            sequence: Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock()
        )
        
        subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, 92)
            case .break(_):
                XCTFail()
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenMixingStatefulAndStatelessBlocks_shouldOutputTheCorrectResult() throws {
        let subject = BlockStatefulFlow(
            state: .init(),
            sequence: Add4Block() --> Add4StateBlock() --> Add4StateBlock() --> Add4Block() --> Add4StateBlock() --> Add4StateBlock() --> Add4Block()
        )
        
        subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, 176)
            case .break(_):
                XCTFail()
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenMultipleSequencesAreConnected_shouldOutputTheCorrectResult() throws {
        let sequence1 = Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock()
        let sequence2 = Add4StateBlock() --> Add4StateBlock()
        let subject = BlockStatefulFlow(
            state: .init(),
            sequence: sequence1 --> sequence2
        )
        
        subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, 380)
            case .break(_):
                XCTFail()
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenMultipleSequencesAreConnected_andSequencesAreMixedStatefulAndStateless_shouldOutputTheCorrectResult() throws {
        let sequence1 = Add4Block() --> Add4Block() --> Add4Block() --> Add4Block()
        let sequence2 = Add4StateBlock() --> Add4StateBlock()
        let subject = BlockStatefulFlow(
            state: .init(),
            sequence: sequence1 --> sequence2
        )
        
        subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, 84)
            case .break(_):
                XCTFail()
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenBlockBreaksEarly_sholdOutputCorrectResult() throws {
        let subject = BlockStatefulFlow(
            state: .init(),
            sequence: Add4Block() --> Add4StateBlock() --> StringBreakBlock() --> ConcatenateStringBlock()
        )
        
        subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, "16-END")
            case .break(_):
                XCTFail()
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenBlockBreaksEarlyInInnerSequence_sholdOutputCorrectResult() throws {
        let sequence1 = Add4StateBlock() --> Add4StateBlock()
        let sequence2 = StringBreakBlock() --> ConcatenateStringBlock() --> ConcatenateStringBlock() --> ConcatenateStringBlock()
        let sequence3 = ConcatenateStringBlock() --> ConcatenateStringBlock()
        let subject = BlockStatefulFlow(
            state: .init(),
            sequence: sequence1 --> sequence2 --> sequence3
        )
        
        subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, "20-END-123-123")
            case .break(_):
                XCTFail()
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenBlockHasVoidInput_sholdOutputCorrectResult() throws {
        let subject = BlockStatefulFlow(
            state: nil,
            sequence: Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock() --> VoidInputIntOutputStateBlock()
        )
        
        subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, 41)
            case .break(_):
                XCTFail()
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenInputAndOutputBlocksHaveVoidInputs_sholdOutputCorrectResult() throws {
        let subject = BlockStatefulFlow(
            state: nil,
            sequence: Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock() --> VoidInputVoidOutputStateBlock() --> VoidInputIntOutputStateBlock()
        )
        
        subject.run(2) { result in
            switch result {
            case .done(let result):
                XCTAssertEqual(result, 41)
            case .break(_):
                XCTFail()
            case .failed(let error):
                XCTFail(error?.localizedDescription ?? "")
            }
        }
    }
    
    func test_run_whenSequenceFails_shouldFailWithError() throws {
        let subject = BlockStatefulFlow(
            state: .init(),
            sequence: Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock() --> IntFailWithErrorStateBlock()
        )
        
        subject.run(2) { result in
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
        let subject = BlockStatefulFlow(
            state: TestState(),
            sequence: Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock() --> Add4StateBlock() --> IntFailWithErrorStateBlock()
        )
        
        subject.run(2) { result in
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
    
    // MARK: - Test Registration
    
    static var allTests = [
        ("test_run_whenTypesMatch_shouldOutputTheCorrectResult", test_run_whenTypesMatch_shouldOutputTheCorrectResult),
        ("test_run_whenMixingStatefulAndStatelessBlocks_shouldOutputTheCorrectResult", test_run_whenMixingStatefulAndStatelessBlocks_shouldOutputTheCorrectResult),
        ("test_run_whenMultipleSequencesAreConnected_shouldOutputTheCorrectResult", test_run_whenMultipleSequencesAreConnected_shouldOutputTheCorrectResult),
        ("test_run_whenMultipleSequencesAreConnected_andSequencesAreMixedStatefulAndStateless_shouldOutputTheCorrectResult", test_run_whenMultipleSequencesAreConnected_andSequencesAreMixedStatefulAndStateless_shouldOutputTheCorrectResult),
        ("test_run_whenBlockBreaksEarly_sholdOutputCorrectResult", test_run_whenBlockBreaksEarly_sholdOutputCorrectResult),
        ("test_run_whenBlockBreaksEarlyInInnerSequence_sholdOutputCorrectResult", test_run_whenBlockBreaksEarlyInInnerSequence_sholdOutputCorrectResult),
        ("test_run_whenSequenceFails_shouldFailWithError", test_run_whenSequenceFails_shouldFailWithError),
        ("test_run_whenSequenceFails_shouldFailWithoutError", test_run_whenSequenceFails_shouldFailWithoutError),
    ]
}
