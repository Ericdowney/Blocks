
import Foundation

public struct Merge<B1: Block, B2: Block>: Block where B1.Input == Void, B2.Input == Void {
    
    // MARK: - Properties
    
    var block1: B1
    var block2: B2
    
    // MARK: - Lifecycle
    
    init(_ block1: B1, _ block2: B2) {
        self.block1 = block1
        self.block2 = block2
    }
    
    // MARK: - Methods
    
    public func run(_: Void, _ context: BlockContext) async throws -> (B1.Output, B2.Output) {
        async let result1 = block1.run(context)
        async let result2 = block2.run(context)
        
        return try await (result1, result2)
    }
}

public struct MergeLeft<B1: Block, B2: Block>: Block where B2.Input == Void {
    
    // MARK: - Properties
    
    var block1: B1
    var block2: B2
    
    // MARK: - Lifecycle
    
    init(_ block1: B1, _ block2: B2) {
        self.block1 = block1
        self.block2 = block2
    }
    
    // MARK: - Methods
    
    public func run(_ input: B1.Input, _ context: BlockContext) async throws -> (B1.Output, B2.Output) {
        async let result1 = block1.run(input, context)
        async let result2 = block2.run(context)
        
        return try await (result1, result2)
    }
}

public struct MergeRight<B1: Block, B2: Block>: Block where B1.Input == Void {
    
    // MARK: - Properties
    
    var block1: B1
    var block2: B2
    
    // MARK: - Lifecycle
    
    init(_ block1: B1, _ block2: B2) {
        self.block1 = block1
        self.block2 = block2
    }
    
    // MARK: - Methods
    
    public func run(_ input: B2.Input, _ context: BlockContext) async throws -> (B1.Output, B2.Output) {
        async let result1 = block1.run(context)
        async let result2 = block2.run(input, context)
        
        return try await (result1, result2)
    }
}
