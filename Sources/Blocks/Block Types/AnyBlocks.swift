
public struct AnyBlock: Block {
    
    private var block: (Any, BlockContext, @escaping (BlockResult<Any>) -> Void) -> Void
    
    public init(block: @escaping (Any, BlockContext, @escaping (BlockResult<Any>) -> Void) -> Void) {
        self.block = block
    }
    
    public func run(_ input: Any, _ context: BlockContext, _ completion: @escaping (BlockResult<Any>) -> Void) {
        block(input, context, completion)
    }
}
