
infix operator -->: AdditionPrecedence

func --><Input1, SequenceBridgeInput, Output2>(sequence1: BlockSequence<Input1, SequenceBridgeInput>, sequence2: BlockSequence<SequenceBridgeInput, Output2>) -> BlockSequence<Input1, Output2> {
    [sequence1.eraseToAnyBlock(), sequence2.eraseToAnyBlock()]
}

func --><State: BlockState, Input1, SequenceBridgeInput, Output2>(sequence1: StateBlockSequence<State, Input1, SequenceBridgeInput>, sequence2: StateBlockSequence<State, SequenceBridgeInput, Output2>) -> StateBlockSequence<State, Input1, Output2> {
    [sequence1.eraseToAnyStateBlock(), sequence2.eraseToAnyStateBlock()]
}

func --><Input, Output, B: Block>(sequence: BlockSequence<Input, Output>, nextBlock: B) -> BlockSequence<Input, Output> {
    BlockSequence<Input, Output>(sequence.blocks + [nextBlock.eraseToAnyBlock()])
}

func --><B1: Block, B2: Block, Input, Output>(previousBlock: B1, nextBlock: B2) -> BlockSequence<Input, Output> where B1.Output == B2.Input {
    BlockSequence<Input, Output>([previousBlock.eraseToAnyBlock(), nextBlock.eraseToAnyBlock()])
}

func --><Input, Output, B: StateBlock>(sequence: StateBlockSequence<B.State, Input, Output>, nextBlock: B) -> StateBlockSequence<B.State, Input, Output> {
    StateBlockSequence<B.State, Input, Output>(nil, sequence.blocks + [nextBlock.eraseToAnyStateBlock()])
}

func --><State, Input, Output, B: Block>(sequence: StateBlockSequence<State, Input, Output>, nextBlock: B) -> StateBlockSequence<State, Input, Output> {
    StateBlockSequence<State, Input, Output>(nil, sequence.blocks + [nextBlock.eraseToAnyBlock()])
}

func --><B1: StateBlock, B2: StateBlock, Input, Output>(previousBlock: B1, nextBlock: B2) -> StateBlockSequence<B1.State, Input, Output> where B1.Output == B2.Input, B1.State == B2.State {
    StateBlockSequence<B1.State, Input, Output>(nil, [previousBlock.eraseToAnyStateBlock(), nextBlock.eraseToAnyStateBlock()])
}

func --><B1: Block, B2: StateBlock, Input, Output>(previousBlock: B1, nextBlock: B2) -> StateBlockSequence<B2.State, Input, Output> where B1.Output == B2.Input {
    StateBlockSequence<B2.State, Input, Output>(nil, [previousBlock.eraseToAnyBlock(), nextBlock.eraseToAnyStateBlock()])
}

func --><B1: StateBlock, B2: Block, Input, Output>(previousBlock: B1, nextBlock: B2) -> StateBlockSequence<B1.State, Input, Output> where B1.Output == B2.Input {
    StateBlockSequence<B1.State, Input, Output>(nil, [previousBlock.eraseToAnyStateBlock(), nextBlock.eraseToAnyBlock()])
}
