
import Foundation
import Blocks

struct AddOne: Block {
    func run(_ input: Int, _ context: BlockContext, _ completor: Completor<Int>) {
        completor.done(input + 1)
    }
}

struct AddTwo: Block {
    func run(_ input: Int, _ context: BlockContext, _ completor: Completor<Int>) {
        completor.done(input + 2)
    }
}

struct AddThree: Block {
    func run(_ input: Int, _ context: BlockContext, _ completor: Completor<Int>) {
        completor.done(input + 3)
    }
}

struct AddFour: Block {
    
    func run(_ input: Int, _ context: BlockContext, _ completor: Completor<Int>) {
        completor.done(input + 4)
    }
}

struct AddFive: Block {
    
    func run(_ input: Int, _ context: BlockContext, _ completor: Completor<Int>) {
        completor.done(input + 5)
    }
}

struct AddStateValue: Block {
    func run(_ input: Int, _ context: BlockContext, _ completor: Completor<Int>) {
        completor.done(input + context.state(CustomState.self).value)
    }
}

struct IntToString: Block {
    
    func run(_ input: Int, _ context: BlockContext, _ completor: Completor<String>) {
        completor.done("\(input)")
    }
}

struct CustomState {
    var value: Int = 2
}
