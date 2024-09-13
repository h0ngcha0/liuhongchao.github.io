---
layout: post
category: Blockchain, Web3
title: Visualize ALPHred VM Execution
---

[ALPHred](https://medium.com/@alephium/meet-alphred-a-virtual-machine-like-no-others-85ce86540025) is a stack-based virtual machine designed for [Alephium](https://www.alephium.org/), used to execute smart contracts on the Alephium blockchain. The need for a specialized VM arises from Alephium's unique stateful UTXO ([sUTXO](https://medium.com/@alephium/an-introduction-to-the-stateful-utxo-model-8de3b0f76749)) model, which supports the [Ethereum](https://ethereum.org/en/) style account model for handling contracts state, as well as the [Bitcoin](https://bitcoin.org/) style immutable UTXO model for secure assets management.


ALPHred also introduced many innovative features to enhance the security and efficiency of smart contracts execution. One example is [Asset Permission System](https://docs.alephium.org/dapps/concepts/asset-permission-system/), which explicitly stipulates the flow of assets at the VM level, giving confidence to developers and users that all asset transfers within the smart contract happen as intended. Together with the UTXOs model, it offers a simpler and more secure user experience by eliminating the token approval risks in systems such as [EVM](https://ethereum.org/en/developers/docs/evm/).

In this article, let's dive into ALPHred's internals with the help of [Alephium Decoder](https://alephium-decoder.softfork.se).

## General Architecture

The ALPHred VM utilizes a stack-based architecture, with a decicated frame stack managing function calls. A new frame is pushed onto the stack when a function is invoked, and removed once the function returns. Each frame contains local variables, an operation stack (`opStack`) and a series of instructions. It also has access to the immutable and mutable fields of the contract, asset balances, block and transaction information, etc. During execution, ALPHred VM processes a sequence of instructions for the function on top of the frame stack, relying on its `opStack` to store intermediate values and operants. These instructions cover a wide range of operations, such as loading and storing local variables and contract fields, approving and transferring assets, initiating local or external function calls, etc. ALPHred VM finishes execution when the last frame is successfully popped out of the stack.

This design enables efficient smart contract execution while maintaining clear separation between different function contexts and contract states.

The following image visualizes the general architecture of ALPHred VM when replaying a [transaction](https://explorer.alephium.org/transactions/c61a3f9a597398ebc79d5aca341d274a72d1a8c89516671f7e8f6a53cef4a82c) on [Alephium Decoder](https://alephium-decoder.softfork.se). On the left hand side, we can see the next VM instructions to be executed for the top frame. On the right hand side, we can see the active frames in the frame stack. [TxScript](https://docs.alephium.org/dapps/concepts/programming-model/#txscript) frame is always at the bottom of the stack since it is the entry point of a Alephium transaction that interacts with the smart contracts. For other frames, it displays the address of the contract where the function belongs to and its method index. It also shows the local variables, asset balances and contract fields that are accessible to the frame if they exist.

<img src="{{ site.baseurl }}/images/vm-architecture.png" alt="Architecture"/>

As we replay the instructions step by step, we can observe the changes for the frame stack and the contract state, as well as the gas consumption for each instruction.

## Key VM Instructions

The ALPHred VM utilizes a set of carefully designed instructions to efficiently manage its operations. Let's explore some of the key instructions that form the backbone of its functionality.

### Load and Store Variables

ALPHred VM provides instructions to load and store variables from the frame's local variables as well as the contract's state (fields).


- `LoadLocal`: Loads a local variable onto the `opStack`.
- `StoreLocal`: Stores the top value from the `opStack` into a local variable.
- `LoadImmField`: Loads an immutable field from the contract onto the `opStack`.
- `LoadMutField`: Loads a mutable field from the contract onto the operation stack.
- `StoreMutField`: Stores the top value from the operation stack into a mutable field of the contract.

These instructions allow the VM to efficiently access and modify both local variables within a function's scope and the contract's state. The distinction between immutable and mutable fields is crucial:

- Immutable fields (`LoadImmField`) are set when the contract is deployed and cannot be changed afterwards. They are used for constant values that should remain the same throughout the contract's lifetime.
- Mutable fields (`LoadMutField`, `StoreMutField`) represent the changeable state of the contract. These can be modified during contract execution, allowing for dynamic state management.

This separation provides a clear distinction between constant and variable contract properties, enhancing both security and efficiency. Immutable fields can be optimized by the VM, while mutable fields allow for flexible state updates as required by the contract's logic.

<img src="{{ site.baseurl }}/images/vm-variables.png" alt="VM Variables" style="width: 500px;"/>

As shown in the image above, the top `LoadMutField` instructions will load the first mutable fields onto the `opStack`. We can also see the `LoadLocal`, `StoreLocal` and `LoadImmField` instructions as well.

### Function Calls

ALPHred VM provides two key instructions for function calls: `callExternal` and `callLocal`. These instructions allow for efficient execution of both inter-contract and intra-contract function calls.

- `callExternal`: This instruction is used to call functions in other contracts. It enables cross-contract interactions, which are essential for building complex decentralized applications. When executing a `callExternal` instruction, the VM creates a new frame for the called function and pushes it onto the frame stack. This new frame includes its own set of local variables and `opStack`, ensuring proper isolation of execution contexts between different contracts.

- `callLocal`: This instruction is used to call functions within the same contract. When a `callLocal` instruction is executed, a new frame is created for the called function and pushed onto the frame stack, but it retains access to the same contract state (immutable and mutable fields) as the calling function.

<img src="{{ site.baseurl }}/images/vm-function-call.png" alt="Function Call" style="width: 500px;"/>

In the image above, we can see an example of a `callExternal` instruction. The VM is about to call a function from another contract: the top of `opStack` is the contract id, the method index is `7` as encoded in the `callExternal` instruction. `U256 2` and `U256 0` represents the number of return values and arguments for this function, which are used by ALPHred VM to perform basic compatibility checks. When the called function returns, the VM will pop out the new frame, push its `2` return values onto the `opStack` of the current frame and continue execution.

### Asset Management

ALPHred VM provides instructions to approve and transfer assets.

- `approveToken`: Approve a certain amount of token to an address.
- `approveALPH`: Approve a certain amount of `ALPH` to an address.
- `transferToken`: Transfer certain amount of token to an address's transaction output.
- `transferALPH`: Transfer certain amount of `ALPH` to an address's transaction output.

<img src="{{ site.baseurl }}/images/vm-asset-management.png" alt="Asset Management" style="width: 500px;"/>


In the image above, we can see an example of `ApproveToken` instruction. The VM is about to approve `U256 1` amount of token `fed6cb5a26e2bcbf0be83f0bf472b45d91a4f68c4e995a12255f4591e75c1000` to address `12aH6to1JQxDFsvJ89jtFCnKEcub5ew8x2EABGEDMTYyK` (see `opStack`). After that the `available` and `approved` asset balance for this address will be updated.

When calling a function, it can only use the assets approved for it. As we can imagine, if we have a tree of method calls, the approved fund will cascade from the root of the tree all the way to the leaves. This is how ALPHred VM supports the [Asset Permission System](https://docs.alephium.org/dapps/concepts/asset-permission-system/), which makes the flow of funds across method calls explicit and enforces constraints on each method, specifying which tokens can be spent and in what amounts.


### Contract Creation

ALPHred VM provides a set of instructions for creating contracts and [subcontracts](https://docs.alephium.org/ralph/contracts/#subcontract) (more on its benefits [here](https://x.com/hongchao/status/1751189481921605788)). These instructions are also how tokens are issued on Alephium.

- Create Contract
   - Base instruction: `createContract`
   - Token variants: `createContractWithToken`, `createContractAndTransferToken`
   - Copy creation versions: `copyCreateContract`, `copyCreateContractWithToken`, `copyCreateContractAndTransferToken`

- Create Subcontract
   - Base instruction: `createSubContract`
   - Token variants: `createSubContractWithToken`, `createSubContractAndTransferToken`
   - Copy creation versions: `copyCreateSubContract`, `copyCreateSubContractWithToken`, `copyCreateSubContractAndTransferToken`

Each base instruction has variants for issuing token (`WithToken`) and transferring those tokens to a recipient (`AndTransferToken`). The `copy` versions allow for creating new contracts based on the code of an existing contract.

<img src="{{ site.baseurl }}/images/vm-contract-creation.png" alt="Contract Creation" style="width: 500px;"/>

In the image above, ALPHred VM is about to create a new subcontract using the `copyCreateSubContract` instruction. On the `opStack` it has its parent contract id, the subcontract path, as well as the the template contract id where it can copy code from. After execution, it will push the new subcontract's id onto the `opStack`. You can read more about `copyCreateSubContract` instruction [here](https://docs.alephium.org/ralph/built-in-functions/#copycreatesubcontract).

### Other Instructions

ALPHred VM includes a variety of other instructions that are essential for smart contract execution and blockchain operations. Here are some of the common instructions, it is not meant to be an exhaustive list.

- Control Flow
   - `Jump`: Unconditional jump to a specified instruction.
   - `IfTrue`: Conditional jump if the top of the stack is true.
   - `IfFalse`: Conditional jump if the top of the stack is false.

- Stack Operations
   - `Pop`: Remove the top element from the stack.
   - `Dup`: Duplicate the top element of the stack.
   - `Swap`: Swap the top two elements of the stack.

- Arithmetic and Logic
   - `I256Add/U256Add`: Add two numbers.
   - `I256Sub/U256Sub`: Subtract two numbers.
   - `I256Mul/U256Mul`: Multiply two numbers.
   - `I256Div/U256Div`: Divide two numbers.
   - `I256Mod/U256Mod`: Compute the modulus of two numbers.
   - `BoolNot`: Logical NOT operation.
   - `BoolAnd`: Bitwise AND operation.
   - `BoolOr`: Bitwise OR operation.
   - `U256Xor`: Bitwise XOR operation.

- Cryptographic Operations
   - `Blake2b`: Compute the Blake2b hash of the input.
   - `Keccak256`: Compute the Keccak256 hash of the input.
   - `Sha256`: Compute the Sha256 hash of the input.
   - `VerifySecP256K1`: Verify a secp256k1 signature.
   - `VerifyED25519`: Verify an ED25519 signature.
   - `EthEcRecover`: Recover an address from an ECDSA signature

- Blockchain Interaction
   - `TxId`: Get the current transaction ID.
   - `BlockTimeStamp`: Get the timestamp of the current block.
   - `BlockTarget`: Get the target of the current block.

- Contract Interaction
   - `DestroySelf`: Destroy the current contract and transfer its balance.

These instructions, along with the instructions highlighted earlier, form the comprehensive instruction set of the ALPHred VM. They enable developers to create complex, secure, and efficient smart contracts on the Alephium blockchain.

## Conclusion

The ALPHred VM is a key component of the Alephium blockchain, offering a robust and secure environment for smart contract execution. Its comprehensive instruction set enables sophisticated operations, efficient asset management, and flexible contract creation. These features, combined with built-in security measures and blockchain-specific operations, make ALPHred VM a solid foundation for developers building on Alephium.
