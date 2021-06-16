
import Foundation
import Blocks

struct AddOne: Block {
    
    func run(_ input: Int, _ context: BlockContext) async throws -> Int {
        input + 1
    }
}

struct AddTwo: Block {
    
    func run(_ input: Int, _ context: BlockContext) async throws -> Int {
        input + 2
    }
}

struct AddThree: Block {
    
    func run(_ input: Int, _ context: BlockContext) async throws -> Int {
        input + 3
    }
}

struct AddFour: Block {
    
    func run(_ input: Int, _ context: BlockContext) async throws -> Int {
        input + 4
    }
}

struct AddFive: Block {
    
    func run(_ input: Int, _ context: BlockContext) async throws -> Int {
        input + 5
    }
}

struct AddStateValue: Block {
    
    func run(_ input: Int, _ context: BlockContext) async throws -> Int {
        input + context.state(CustomState.self).value
    }
}

struct IntToString: Block {
    
    func run(_ input: Int, _ context: BlockContext) async throws -> String {
        "\(input)"
    }
}

struct CustomState {
    var value: Int = 2
}
