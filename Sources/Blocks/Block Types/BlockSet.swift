
public struct BlockSet<SequenceInput, SequenceOutput, State>: Block, ExpressibleByArrayLiteral, ExpressibleByNilLiteral {
    
    // MARK: - Properties
    
    var blocks: [AnyBlock]
    
    // MARK: - Lifecycle
    
    public init(arrayLiteral elements: AnyBlock...) {
        self.blocks = elements
    }
    
    public init(_ elements: [AnyBlock] = []) {
        self.blocks = elements
    }
    
    public init(nilLiteral: ()) {
        self.blocks = []
    }
    
    // MARK: - Methods
    
    public mutating func append<B: Block>(_ block: B) {
        blocks.append(block.eraseToAnyBlock())
    }
    
    public func run(_ input: SequenceInput, _ context: BlockContext<State>, _ completion: @escaping (BlockResult<SequenceOutput>) -> Void) {
        guard blocks.count > 0 else { return completion(.failed(BlockError.emptyBlockSequence)) }
        
        run(at: 0, input, context, completion)
    }
    
    private func run(at index: Int, _ nextInput: Any, _ context: BlockContext<State>, _ completion: @escaping (BlockResult<SequenceOutput>) -> Void) {
        if let block = blocks.value(at: index) {
            block.run(nextInput, BlockContext(state: context.state as Any)) { result in
                switch result {
                case .done(let nextInput):
                    run(at: index + 1, nextInput, context, completion)
                case .break(let output):
                    if let output = output as? SequenceOutput {
                        completion(.done(output))
                    } else {
                        completion(.failed(BlockError.unmatchedOutputTypes))
                    }
                case .failed(let error):
                    completion(.failed(error))
                }
            }
        } else if let output = nextInput as? SequenceOutput {
            completion(.done(output))
        } else {
            completion(.failed(BlockError.unmatchedOutputTypes))
        }
    }
}
