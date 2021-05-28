
import Foundation

public struct Filter<Iterable: Sequence>: Block {
    
    private var filter: (Iterable.Element) -> Bool
    
    public func run(_ input: Iterable, _ context: BlockContext, _ completor: Completor<[Iterable.Element]>) {
        completor.done(
            input.filter(filter)
        )
    }
}

