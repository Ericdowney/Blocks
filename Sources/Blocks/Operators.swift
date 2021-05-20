
infix operator -->: AdditionPrecedence

// MARK: - Sequences

public func --><Input1, SequenceBridgeInput, Output2, State>(sequence1: BlockSet<Input1, SequenceBridgeInput, State>, sequence2: BlockSet<SequenceBridgeInput, Output2, State>) -> BlockSet<Input1, Output2, State> {
    [sequence1.eraseToAnyBlock(), sequence2.eraseToAnyBlock()]
}

// MARK: - Blocks

public func --><B1: Block, B2: Block, State>(previousBlock: B1, nextBlock: B2) -> BlockSet<B1.Input, B2.Output, State> where B1.Output == B2.Input, B1.State == B2.State, B1.State == State {
    if let sequence = previousBlock as? BlockSet<B1.Input, B1.Output, State> {
        return BlockSet<B1.Input, B2.Output, State>(sequence.blocks + [nextBlock.eraseToAnyBlock()])
    } else if let sequence = nextBlock as? BlockSet<B2.Input, B2.Output, State> {
        return BlockSet<B1.Input, B2.Output, State>([previousBlock.eraseToAnyBlock()] + sequence.blocks)
    }
    return BlockSet<B1.Input, B2.Output, State>([previousBlock.eraseToAnyBlock(), nextBlock.eraseToAnyBlock()])
}

public func --><B1: Block, B2: Block, State>(previousBlock: B1, nextBlock: B2) -> BlockSet<B1.Input, B2.Output, State> where B2.Input == Void, B1.State == B2.State, B1.State == State {
    if let sequence = previousBlock as? BlockSet<B1.Input, B1.Output, State> {
        return BlockSet<B1.Input, B2.Output, State>(sequence.blocks + [nextBlock.eraseToAnyVoidBlock()])
    } else if let sequence = nextBlock as? BlockSet<B2.Input, B2.Output, State> {
        return BlockSet<B1.Input, B2.Output, State>([previousBlock.eraseToAnyBlock()] + sequence.blocks)
    }
    return BlockSet<B1.Input, B2.Output, State>([previousBlock.eraseToAnyBlock(), nextBlock.eraseToAnyVoidBlock()])
}

public func --><B1: Block, B2: Block, State>(previousBlock: B1, nextBlock: B2) -> BlockSet<B1.Input, B2.Output, State> where B1.Output == B2.Input, B2.Input == Void, B1.State == B2.State, B1.State == State {
    if let sequence = previousBlock as? BlockSet<B1.Input, B1.Output, State> {
        return BlockSet<B1.Input, B2.Output, State>(sequence.blocks + [nextBlock.eraseToAnyVoidBlock()])
    } else if let sequence = nextBlock as? BlockSet<B2.Input, B2.Output, State> {
        return BlockSet<B1.Input, B2.Output, State>([previousBlock.eraseToAnyBlock()] + sequence.blocks)
    }
    return BlockSet<B1.Input, B2.Output, State>([previousBlock.eraseToAnyBlock(), nextBlock.eraseToAnyVoidBlock()])
}
