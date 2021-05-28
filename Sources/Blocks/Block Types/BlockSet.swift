
public struct BlockSet<SequenceInput, SequenceOutput>: Block, ExpressibleByArrayLiteral, ExpressibleByNilLiteral {
    
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
    
    public func run(_ input: SequenceInput, _ context: BlockContext, _ completor: Completor<SequenceOutput>) {
        guard blocks.count > 0 else { return completor.failed(BlockError.emptyBlockSequence) }
        
        run(at: 0, input, context, completor)
    }
    
    private func run(at index: Int, _ nextInput: Any, _ context: BlockContext, _ completor: Completor<SequenceOutput>) {
        if let block = blocks.value(at: index) {
            block.run(nextInput, BlockContext(state: context._state)) { result in
                switch result {
                case .done(let nextInput):
                    run(at: index + 1, nextInput, context, completor)
                case .break(let output):
                    if let output = output as? SequenceOutput {
                        completor.done(output)
                    } else {
                        completor.failed(BlockError.unmatchedOutputTypes)
                    }
                case .failed(let error):
                    completor.failed(error)
                }
            }
        } else if let output = nextInput as? SequenceOutput {
            completor.done(output)
        } else {
            completor.failed(BlockError.unmatchedOutputTypes)
        }
    }
}
