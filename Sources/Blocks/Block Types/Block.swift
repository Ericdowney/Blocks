
public protocol Block {
    associatedtype Input
    associatedtype Output
    typealias Completion = (BlockResult<Output>) -> Void
    
    func run(_ input: Input, _ context: BlockContext, _ completion: @escaping Completion)
}
