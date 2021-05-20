
public protocol Block {
    associatedtype Input
    associatedtype Output
    associatedtype State
    typealias Completion = (BlockResult<Output>) -> Void
    
    func run(_ input: Input, _ context: BlockContext<State>, _ completion: @escaping Completion) throws
}
