
public protocol Block {
    associatedtype Input
    associatedtype Output
    
    func run(_ input: Input, _ context: BlockContext, _ completor: Completor<Output>)
}

extension Block {
    
    func run(_ input: Input, _ context: BlockContext, _ completion: @escaping (BlockResult<Output>) -> Void) {
        run(input, context, Completor(completion))
    }
}

public final class Completor<Output> {
    
    public private(set) var progress: Float = 0.0 {
        didSet { _progress?(progress) }
    }
    
    private var _block: (BlockResult<Output>) -> Void
    private var _progress: ((Float) -> Void)?
    
    init(_ block: @escaping (BlockResult<Output>) -> Void, _ progress: ((Float) -> Void)? = nil) {
        self._block = block
        self._progress = progress
    }
    
    public func set(progress value: Float) {
        self.progress = value
    }
    
    public func done(_ value: Output) {
        _block(.done(value))
    }
    
    public func `break`(_ value: Output) {
        _block(.break(value))
    }
    
    public func failed(_ error: Error?) {
        _block(.failed(error))
    }
}
