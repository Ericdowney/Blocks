
public struct AnyBlock: Block {
    
    private var block: (Any, BlockContext, Completor<Any>) -> Void
    
    public init(block: @escaping (Any, BlockContext, Completor<Any>) -> Void) {
        self.block = block
    }
    
    public func run(_ input: Any, _ context: BlockContext, _ completor: Completor<Any>) {
        block(input, context, completor)
    }
}
