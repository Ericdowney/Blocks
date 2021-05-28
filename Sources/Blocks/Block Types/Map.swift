
import Foundation

public struct Map<Input: Sequence, Output: Sequence>: Block {
    
    var map: (Input.Element) -> Output.Element
    
    public func run(_ input: Input, _ context: BlockContext, _ completor: Completor<[Output.Element]>) {
        completor.done(
            input.map(map)
        )
    }
}

public struct CompactMap<Input: Sequence, Output: Sequence>: Block {
    
    var map: (Input.Element) -> Output.Element?
    
    public func run(_ input: Input, _ context: BlockContext, _ completor: Completor<[Output.Element]>) {
        completor.done(
            input.compactMap(map)
        )
    }
}
