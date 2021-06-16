
public struct AnyBlock: Block {
    
    private var block: (Any, BlockContext) async throws -> Any
    
    public init(block: @escaping (Any, BlockContext) async throws -> Any) {
        self.block = block
    }
    
    public func run(_ input: Any, _ context: BlockContext) async throws -> Any {
        try await block(input, context)
    }
}
