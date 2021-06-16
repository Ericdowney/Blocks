
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
        
        return try await run(at: 0, previousOutput: input, context)
    }
    
    private func run(at index: Int, previousOutput nextInput: Any, _ context: BlockContext) async throws -> SequenceOutput {
        if let block = blocks.value(at: index) {
            return try await run(at: index + 1,
                                 previousOutput: try await block.run(nextInput, context),
                                 context)
        } else if let output = nextInput as? SequenceOutput {
            return output
        }
        throw BlockError.unmatchedOutputTypes
    }
}
