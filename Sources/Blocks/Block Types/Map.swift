
import Foundation

public struct Map<Input: Sequence, Output: Sequence>: Block {
    
    var transform: (Input.Element) -> Output.Element
    
    public init(transform: @escaping (Input.Element) -> Output.Element) {
        self.transform = transform
    }
    
    public func run(_ input: Input, _ context: BlockContext) async throws -> [Output.Element] {
        input.map(transform)
    }
}

public struct Transform<Input, Output>: Block {
    
    var transform: (Input) -> Output
    
    public init(transform: @escaping (Input) -> Output) {
        self.transform = transform
    }
    
    public func run(_ input: Input, _ context: BlockContext) async throws -> Output {
        transform(input)
    }
}

public struct MapValue<Input, Output>: Block {
    
    var map: (Input) -> Output
    
    public init(map: @escaping (Input) -> Output) {
        self.map = map
    }
    
    public func run(_ input: Input?, _ context: BlockContext) async throws -> Output? {
        input.map(map)
    }
}

public struct CompactMap<Input: Sequence, Output: Sequence>: Block {
    
    var transform: (Input.Element) -> Output.Element?
    
    public init(transform: @escaping (Input.Element) -> Output.Element?) {
        self.transform = transform
    }
    
    public func run(_ input: Input, _ context: BlockContext) async throws -> [Output.Element] {
        input.compactMap(transform)
    }
}
