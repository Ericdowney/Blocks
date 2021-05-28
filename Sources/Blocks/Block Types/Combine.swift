
import Foundation

public struct Combine<B1: Block, B2: Block>: Block where B1.Input == B2.Input {
    public typealias Input = B1.Input
    
    var block1: B1
    var block2: B2
    
    public init(block1: B1, block2: B2) {
        self.block1 = block1
        self.block2 = block2
    }
    
    public func run(_ input: Input, _ context: BlockContext, _ completor: Completor<(B1.Output, B2.Output)?>) {
        block1.run(input, context, .init { result1 in
            switch result1 {
            case .done(let output1):
                block2.run(input, context, .init { result2 in
                    switch result2 {
                    case .done(let output2):
                        completor.done((output1, output2))
                    case .break(let output2):
                        completor.break((output1, output2))
                    case .failed(let error):
                        completor.failed(error)
                    }
                })
            case .break(_):
                completor.break(nil)
            case .failed(let error):
                completor.failed(error)
            }
        })
    }
}
