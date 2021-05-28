
import Foundation

public struct Map<Input: Sequence, Output: Sequence>: Block {
    
    var transform: (Input.Element) -> Output.Element
    
    public init(transform: @escaping (Input.Element) -> Output.Element) {
        self.transform = transform
    }
    
    public func run(_ input: Input, _ context: BlockContext, _ completor: Completor<[Output.Element]>) {
        completor.done(
            input.map(transform)
        )
    }
}

public struct MapValue<Input, Output>: Block {
    
    var map: (Input) -> Output
    
    public init(map: @escaping (Input) -> Output) {
        self.map = map
    }
    
    public func run(_ input: Input?, _ context: BlockContext, _ completor: Completor<Output?>) {
        completor.done(
            input.map(map)
        )
    }
}

public struct CompactMap<Input: Sequence, Output: Sequence>: Block {
    
    var transform: (Input.Element) -> Output.Element?
    
    public init(transform: @escaping (Input.Element) -> Output.Element?) {
        self.transform = transform
    }
    
    public func run(_ input: Input, _ context: BlockContext, _ completor: Completor<[Output.Element]>) {
        completor.done(
            input.compactMap(transform)
        )
    }
}
