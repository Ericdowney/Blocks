
import Foundation
import Blocks

struct AddOne: Block {
    func run(_ input: Int, _ context: BlockContext, _ completion: @escaping (BlockResult<Int>) -> Void) {
        completion(.done(input + 1))
    }
}

struct AddTwo: Block {
    func run(_ input: Int, _ context: BlockContext, _ completion: @escaping (BlockResult<Int>) -> Void) {
        completion(.done(input + 2))
    }
}

struct AddThree: Block {
    func run(_ input: Int, _ context: BlockContext, _ completion: @escaping (BlockResult<Int>) -> Void) {
        completion(.done(input + 3))
    }
}

struct AddFour: Block {
    
    func run(_ input: Int, _ context: BlockContext, _ completion: @escaping (BlockResult<Int>) -> Void) {
        completion(.done(4 + input))
    }
}

struct AddStateValue: Block {
    func run(_ input: Int, _ context: BlockContext, _ completion: @escaping (BlockResult<Int>) -> Void) {
        completion(.done(input + context.state(CustomState.self).value))
    }
}

struct IntToString: Block {
    
    func run(_ input: Int, _ context: BlockContext, _ completion: @escaping (BlockResult<String>) -> Void) {
        completion(.done("\(input)"))
    }
}

struct CustomState {
    var value: Int = 2
}
