
import Foundation

public struct PassThroughInput<Input>: Block {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    public init() {}
    
    // MARK: - Methods
    
    public func run(_ input: Input, _ context: BlockContext) async throws -> Input {
        input
    }
}
