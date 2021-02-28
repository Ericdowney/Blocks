
public protocol Block {
    associatedtype Input
    associatedtype Output
    typealias Completion = (BlockResult<Output>) throws -> Void
    
    func run(_ input: Input, _ completion: @escaping Completion) throws
}

public protocol StateBlock: Block {
    associatedtype State
    
    var _state: AssuredValue<State> { get }
}
