
public protocol Block {
    associatedtype Input
    associatedtype Output
    
    func run(_ input: Input, _ context: BlockContext) async throws -> Output
}
