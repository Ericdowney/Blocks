
import Foundation

public struct Concurrent<B1: Block, B2: Block>: Block where B1.Input == B2.Input {
    
    var block1: B1
    var block2: B2
    
    public init(_ block1: B1, _ block2: B2) {
        self.block1 = block1
        self.block2 = block2
    }
    
    public func run(_ input: B1.Input, _ context: BlockContext) async throws -> (B1.Output, B2.Output) {
        async let output1 = block1.run(input, context)
        async let output2 = block2.run(input, context)
        
        return try await (output1, output2)
    }
}
