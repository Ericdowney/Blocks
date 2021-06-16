
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
    
    public func run(_ input: SequenceInput, _ context: BlockContext) async throws -> SequenceOutput {
        guard blocks.count > 0 else { throw BlockError.emptyBlockSequence }
        
        var nextInput: Any = input
        var nextOutput: Any?
        for block in blocks {
            let output = try await block.run(nextInput, context)
            nextInput = output
            nextOutput = output
        }
        
        guard let output = nextOutput as? SequenceOutput else { throw BlockError.unmatchedOutputTypes }
        return output
    }
}
