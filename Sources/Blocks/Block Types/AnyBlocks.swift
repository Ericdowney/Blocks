
protocol TypeErasedBlock {}

public struct AnyBlock: Block, TypeErasedBlock {
    
    private var block: (Any, @escaping (BlockResult<Any>) -> Void) -> Void
    
    public init(block: @escaping (Any, @escaping (BlockResult<Any>) -> Void) -> Void) {
        self.block = block
    }
    
    public func run(_ input: Any, _ completion: @escaping (BlockResult<Any>) -> Void) {
        block(input, completion)
    }
}

public struct AnyStateBlock: StateBlock, TypeErasedBlock {
    
    public internal(set) var _state: AssuredValue<Any>
    private var block: (Any, Any, @escaping (BlockResult<Any>) -> Void) -> Void
    
    public init(block: @escaping (Any, Any, @escaping (BlockResult<Any>) -> Void) -> Void) {
        self._state = .init()
        self.block = block
    }
    
    public init(state: Any, block: @escaping (Any, Any, @escaping (BlockResult<Any>) -> Void) -> Void) {
        self._state = .init(state)
        self.block = block
    }
    
    public func run(_ input: Any, _ completion: @escaping (BlockResult<Any>) -> Void) {
        block(_state.wrappedValue as Any, input, completion)
    }
}
