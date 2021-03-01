
infix operator -->: AdditionPrecedence

// MARK: - Sequences

public func --><Input1, SequenceBridgeInput, Output2>(sequence1: BlockSequence<Input1, SequenceBridgeInput>, sequence2: BlockSequence<SequenceBridgeInput, Output2>) -> BlockSequence<Input1, Output2> {
    [sequence1.eraseToAnyBlock(), sequence2.eraseToAnyBlock()]
}

public func --><State: BlockState, Input1, SequenceBridgeInputOutput, Output2>(sequence1: StateBlockSequence<State, Input1, SequenceBridgeInputOutput>, sequence2: StateBlockSequence<State, SequenceBridgeInputOutput, Output2>) -> StateBlockSequence<State, Input1, Output2> {
    [sequence1.eraseToAnyStateBlock(), sequence2.eraseToAnyStateBlock()]
}

// MARK: - Blocks

public func --><B1: Block, B2: Block>(previousBlock: B1, nextBlock: B2) -> BlockSequence<B1.Input, B2.Output> where B1.Output == B2.Input {
    if let sequence = previousBlock as? BlockSequence<B1.Input, B1.Output> {
        return BlockSequence<B1.Input, B2.Output>(sequence.blocks + [nextBlock.eraseToAnyBlock()])
    } else if let sequence = nextBlock as? BlockSequence<B1.Input, B1.Output> {
        return BlockSequence<B1.Input, B2.Output>([previousBlock.eraseToAnyBlock()] + sequence.blocks)
    }
    return BlockSequence<B1.Input, B2.Output>([previousBlock.eraseToAnyBlock(), nextBlock.eraseToAnyBlock()])
}


// MARK: - State Blocks

public func --><B1: StateBlock, B2: StateBlock>(previousBlock: B1, nextBlock: B2) -> StateBlockSequence<B1.State, B1.Input, B2.Output> where B1.Output == B2.Input, B1.State == B2.State {
    if let sequence = previousBlock as? StateBlockSequence<B1.State, B1.Input, B1.Output> {
        return StateBlockSequence<B1.State, B1.Input, B2.Output>(nil, sequence.blocks + [nextBlock.eraseToAnyStateBlock()])
    } else if let sequence = nextBlock as? StateBlockSequence<B1.State, B1.Input, B1.Output> {
        return StateBlockSequence<B1.State, B1.Input, B2.Output>(nil, [previousBlock.eraseToAnyBlock()] + sequence.blocks)
    }
    return StateBlockSequence<B1.State, B1.Input, B2.Output>(nil, [previousBlock.eraseToAnyStateBlock(), nextBlock.eraseToAnyStateBlock()])
}

public func --><B1: Block, B2: StateBlock>(previousBlock: B1, nextBlock: B2) -> StateBlockSequence<B2.State, B1.Input, B2.Output> where B1.Output == B2.Input {
    if let sequence = previousBlock as? BlockSequence<B1.Input, B1.Output> {
        return StateBlockSequence<B2.State, B1.Input, B2.Output>(nil, sequence.blocks + [nextBlock.eraseToAnyStateBlock()])
    } else if let sequence = nextBlock as? StateBlockSequence<B2.State, B1.Input, B1.Output> {
        return StateBlockSequence<B2.State, B1.Input, B2.Output>(nil, [previousBlock.eraseToAnyBlock()] + sequence.blocks)
    }
    return StateBlockSequence<B2.State, B1.Input, B2.Output>(nil, [previousBlock.eraseToAnyBlock(), nextBlock.eraseToAnyStateBlock()])
}

public func --><B1: StateBlock, B2: Block>(previousBlock: B1, nextBlock: B2) -> StateBlockSequence<B1.State, B1.Input, B2.Output> where B1.Output == B2.Input {
    if let sequence = previousBlock as? StateBlockSequence<B1.State, B1.Input, B1.Output> {
        return StateBlockSequence<B1.State, B1.Input, B2.Output>(nil, sequence.blocks + [nextBlock.eraseToAnyBlock()])
    } else if let sequence = nextBlock as? BlockSequence<B1.Input, B1.Output> {
        return StateBlockSequence<B1.State, B1.Input, B2.Output>(nil, [previousBlock.eraseToAnyBlock()] + sequence.blocks)
    }
    return StateBlockSequence<B1.State, B1.Input, B2.Output>(nil, [previousBlock.eraseToAnyStateBlock(), nextBlock.eraseToAnyBlock()])
}
