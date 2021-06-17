
import Foundation

public struct PassThroughInput<Input>: Block {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    // MARK: - Methods
    
    public func run(_ input: Input, _ context: BlockContext) async throws -> Input {
        input
    }
}
