---
layout: post
category: Bitcoin, Blockchain
title: Learn You Some Crypto for Good
---

In the past few days, the market has crashed hard on basically
everything, including Bitcoin. Financial losses naturally come with
negative emotions and various theories of justification. Is cronavirus
really the culprit? Or is it just an excuse for something more
fundamental? Perhaps nobody really knows since it might require a
certain amount of higher dimensional insights which most of us frankly
do not pocess. Surprisingly, I wasn't that much affected emotionally
by the price this time like the roller coaster feeling I got from 2017
to 2018. Perhaps it has to do with the fact that my growing
appreciation to the crypto space (primarily Bitcoin) over the years
makes it much more than just a financial investment. As a
technologist, it not only fascinates me on the technical side, but
also serves as a forcing function for me to learn a little bit more
about disciplines such as *politics*, *economics*, *finance* and
*game theories*, etc. In restrospect, I feel this learning experience
is very rewarding and a journey well worth taking. In this post, I
will try to explain why.

#### Technology

Blockchain is fascinating from the technical perspective. It was
invented to solve the [double spend
problem](https://en.wikipedia.org/wiki/Double-spending) in a
decentralized setting without requiring a trusted third party. It
achieves that with the interplay of two components: First, a
modification resistent data structure for storing all the
transactions. Turns out that one efficient implementation is to
organize transations into sequence of blocks, each of which containing
a cryptographic hash of the previous one, resulting a chain of
blocks. Second, a method to reach consensus among a set of networked
computers of certain topology as to who should have the right to
append the next block onto the blockchain, called the [consensus
algorithm](https://en.wikipedia.org/wiki/Consensus_(computer_science)).

A key contribution of Bitcoin as the first blockchain is that an
incentive structure is built right into the consensus mechanism
through the use of [Proof of
Work](https://en.wikipedia.org/wiki/Proof_of_work) which coordinates
the economic activities in the ecosystem of miners, merchants,
engineers, exchanges, users, etc, resulting the world's first
[dencentralized autonomous
organization](https://en.wikipedia.org/wiki/Decentralized_autonomous_organization).
This is a significant milestone in computer engineering since for the
first time, engineers can program trust and incentives without
delegating that to a centralized entity. Since the world at its base
layer is fundamentally decentralized and governed by law of physics
and different incentive structures, theoretically this gives
engineers the power of genisis creation in whatever the "universe" they
are creating. [Governance, talk about goverance]. 

Crypto also offers a set of unique challenges when it comes to
software engineering. Deploying software updates in a decentralized
p2p network is very difficult, especially when consensus over a shared
state needs to be maintained by different versions of the software at
the same time (see
[Forkology](https://www.youtube.com/watch?v=rpeceXY1QBM)). When money
is quite literally on the line and the cost of introducing and fixing
bugs could be extremely high, [move fast and break
things](https://en.wikipedia.org/wiki/Facebook,_Inc.#History) is
definitely not an option. In fact, the development of systems such as
Bitcoin should go through the same level of scrutiny and testing as
aerospace software and its deployment should be analogous to shipping
hardware. [Formal
verification](https://en.wikipedia.org/wiki/Formal_verification), a
technique that hasn't seen much adoption in many software projects due
to its formidable cost, becomes much more economically feasible in
crypto space considering the amount of value at
stake. [MakerDao](https://makerdao.com/), for example, [formally
verified](https://security.makerdao.com/formal-verification) all the
core contracts in its MCD system.

There are also a set of difficult technical problems in the crypto
space. One of them is **scalability** of the blockchain, which is hard
to achieve without sacrificing its security and decentralization
properties (see [scalability
trilemmas](https://bitcoinist.com/breaking-down-the-scalability-trilemma/)).
[Ethereum](https://ethereum.org/)'s response to that is to leverage
some clever constructions of [proof of
stake](https://en.wikipedia.org/wiki/Proof_of_stake) and
[sharding](https://docs.ethhub.io/ethereum-roadmap/ethereum-2.0/sharding/),
while the answer from the Bitcoin community right now is mostly 2nd
layer solutions such as [lightning
network](https://lightning.network/). Since the value proposition of a
blockchain is security and decentralization, trading too much of these
two properties off for scalability is generally not desirable. Still
lots of work remains to be done before blockchain can scale to mass
adoption. **Privacy** is another important area of research &
development in the space. [Satoshi
Nakamoto](https://en.wikipedia.org/wiki/Satoshi_Nakamoto) famously
said in the [Bitcoin white paper](https://bitcoin.org/bitcoin.pdf)
that *The only way to confirm the absence of a transaction is to be
aware of all transactions*. There is always a tension between making
everything publicly verifiable and the need for obfuscation.  Bitcoin
does not have good privacy built into the protocol layer, [many
technologies](http://hongchao.me/bitcoin-privacy/) have been invented
to improve that since its inception. Some blockchains try to introduce
certain privacy features into the protocol
layer. [Monero](https://www.getmonero.org/), for example, leverages
[ring signatures](https://en.wikipedia.org/wiki/Ring_signature) to
obfuscate the transaction graph and [confidential
transaction](https://people.xiph.org/~greg/confidential_values.txt) to
hide transaction amount. [Zcash](https://en.wikipedia.org/wiki/Zcash)
leverages a type of [zero-knowledge
proof](https://en.wikipedia.org/wiki/Zero-knowledge_proof) called
[zk-SNARKs](https://en.wikipedia.org/wiki/Non-interactive_zero-knowledge_proof)
to make transaction completely private. Both of them sacrifices
scalability to some extent since they make the transactions and thus
the blockchain significantly larger than
Bitcoin. [Mimblewimble](https://en.wikipedia.org/wiki/MimbleWimble)
also uses confidential transaction to hide the transaction amount, but
it also made an observation that the type of the encryption underneath
confidential transaction, called [homomorphic
encryption](https://en.wikipedia.org/wiki/Homomorphic_encryption), can
also be used in a clever way (through algebras) to expression
[ownership](https://github.com/mimblewimble/grin/blob/master/doc/intro.md#ownership)
of the coin. Through a mechanism called
[cut-through](https://github.com/mimblewimble/grin/blob/master/doc/intro.md#cut-through),
mimblewimble blockchain can be made very compact thus
increases both its privacy and salability at the same time. Extending the
insights from the MimbleWimble protocol, in general the ability to perform
algebras with digital signatures (e.g. with [Schnorr
signatures](https://en.wikipedia.org/wiki/Schnorr_signature)) opens up
the door for various kinds of smart contracts to be built in such a way
that is indistinguishable from a single signature transaction, one example
is
[MuSig](https://blockstream.com/2019/02/18/en-musig-a-new-multisignature-standard/).


#### The need for alternatives

counter for Big Corp data thing

#### Grand Vision

#### Personal Habit


