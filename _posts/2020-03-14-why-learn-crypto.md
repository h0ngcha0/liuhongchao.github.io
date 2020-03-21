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
also serves as a forcing function for me to learn a bit more about
other disciplines such as *politics*, *economics*, *finance*,
*philosophy* and *game theories*, etc. In restrospect, I feel this
learning experience is very rewarding and a journey well worth
taking. In this post, I will try to explain why.

### Fascinating Technologies

Blockchain is fascinating from the technical perspective. It was
invented to solve the [double spend
problem](https://en.wikipedia.org/wiki/Double-spending) in a
decentralized setting without requiring a trusted third party. It
achieves that with the interplay of two components: First, a
modification resistent data structure for storing all the
transactions. It turns out that an efficient implementation is to
organize transations into sequence of blocks, each of which contains
a cryptographic hash of the previous one, resulting a chain of blocks,
hence the name *blockchain*. Second, a method to reach consensus among a
set of networked computers of certain topology as to who should have
the right to append the next block onto the blockchain, called a
[consensus
algorithm](https://en.wikipedia.org/wiki/Consensus_(computer_science)).

A key contribution of Bitcoin as the first blockchain is that an
incentive structure is built right into the consensus algorithm
through the use of [proof of
work](https://en.wikipedia.org/wiki/Proof_of_work) which coordinates
the economic activities in the ecosystem of miners, merchants,
engineers, exchanges, users, etc, resulting the world's first
[dencentralized autonomous
organization](https://en.wikipedia.org/wiki/Decentralized_autonomous_organization).
This is a significant milestone in computer engineering since for the
first time, engineers can **program trust and incentives** without
delegating that to a centralized entity. Since the world at its base
layer is fundamentally decentralized and governed by law of physics
and different incentive structures, theoretically this gives engineers
the power of genisis creation in whatever the "universe" they are
creating. Consensus algorithm is an active area of research in the
space with a lot of thought provoking exploration and debates, the
most notably alternative to proof of work is various forms of [proof
of stake](https://en.wikipedia.org/wiki/Proof_of_stake). At the end of
the day, they are all supposed to help the blockchain achieve [byzantin
fault tolerance](https://en.wikipedia.org/wiki/Byzantine_fault).

There many other difficult technical problems in the crypto space. One
of them is blockchain **scalability**, which is hard to achieve
without also sacrificing its **security** and **decentralization** properties
(see [scalability
trilemmas](https://bitcoinist.com/breaking-down-the-scalability-trilemma/)).
[Ethereum](https://ethereum.org/)'s response to that seems to be
leveraging clever constructions of [proof of
stake](https://en.wikipedia.org/wiki/Proof_of_stake) and
[sharding](https://docs.ethhub.io/ethereum-roadmap/ethereum-2.0/sharding/),
while the answer from the Bitcoin community at the moment is mostly
2nd layer solutions such as [lightning
network](https://lightning.network/). Since the value proposition of a
blockchain is security and decentralization, trading off too much of
these two properties is generally not desirable (e.g. [blocksize
debate](https://en.bitcoin.it/wiki/Block_size_limit_controversy)). For
blockchain to achieve mass adoption, a lot more research and
development as well as real life battle testing remains to be
done. **Privacy** is another important area of research & development
in the space. [Satoshi
Nakamoto](https://en.wikipedia.org/wiki/Satoshi_Nakamoto) famously
said in the Bitcoin [white paper](https://bitcoin.org/bitcoin.pdf)
that *The only way to confirm the absence of a transaction is to be
aware of all transactions*. There is always a tension between making
everything publicly verifiable and the need for obfuscation.  Bitcoin
does not have good privacy built into the protocol layer, [many
technologies](http://hongchao.me/bitcoin-privacy/) have been invented
to improve that ever since its inception. Some blockchains try to
introduce certain privacy features into the protocol
layer. [Monero](https://www.getmonero.org/), for example, leverages
[ring signatures](https://en.wikipedia.org/wiki/Ring_signature) to
obfuscate the transaction graph and [confidential
transaction](https://people.xiph.org/~greg/confidential_values.txt) to
hide transaction amount. [Zcash](https://en.wikipedia.org/wiki/Zcash)
leverages a type of [zero-knowledge
proof](https://en.wikipedia.org/wiki/Zero-knowledge_proof) called
[zk-SNARKs](https://en.wikipedia.org/wiki/Non-interactive_zero-knowledge_proof)
to make *shielded* transaction completely private. Both of them
sacrifices scalability to some extent since they make the transactions
and thus the blockchain significantly
heavier. [Mimblewimble](https://en.wikipedia.org/wiki/MimbleWimble)
also uses confidential transaction to hide the transaction amount, but
it goes a bit further by leveraging the encryption underneath
confidential transaction (called [homomorphic
encryption](https://en.wikipedia.org/wiki/Homomorphic_encryption)) in
a clever way to expression coin
[ownership](https://github.com/mimblewimble/grin/blob/master/doc/intro.md#ownership)
as well. Interestingly, through a mechanism called
[cut-through](https://github.com/mimblewimble/grin/blob/master/doc/intro.md#cut-through),
mimblewimble blockchain can be made very compact thus achieves both
privacy and scalability at the same time. Another approach to improve
both privacy and scalability is through the use of zero knowledge
proofs to generate proofs offchain and only perform verification
onchain, as what [Stackware](https://starkware.co/) and
[Coda](https://codaprotocol.com/) aim to achieve. Privacy and
scalability are so intimately related, another example is [lightning
network](https://lightning.network/), even thought intended as a
scalability solution, it also has privacy implications because it can
potentially move most of the Bitcoin transactions offchain.

**Programmability** is also a point of contention in the crypto
space. Bitcoin's [scripting](https://en.bitcoin.it/wiki/Script) system
allows the creation of [smart
contract](https://en.wikipedia.org/wiki/Smart_contract) and is
purposefully not turing complete to avoid the [halting
problem](https://en.wikipedia.org/wiki/Halting_problem). The progress
made in lightning network development demonstrated how much can be
achieved despite of this limitation. This design choice is very much
in line with the philosophy where blockchain is [not for computation
but for
verification](https://bitcointalk.org/index.php?topic=1427885.msg14601127#msg14601127).
What nodes really care about is a proof that certain computation was
performed, repeating the same computation is just one way to
achieve it. With this philosophy, many proposals have been made to improve
the existing Bitcoin scripting system. [Schnorr
signature](https://en.wikipedia.org/wiki/Schnorr_signature), a
digital signature scheme that offers the ability to perform algebra
on signatures, is hopefully soon [coming](https://github.com/sipa/bips/blob/bip-schnorr/bip-schnorr.mediawiki)
to Bitcoin. This paves the way for technologies such as signature
aggregation,
[Taproot](https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2018-January/015614.html)
and
[Graftroot](https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2018-February/015700.html)
which are great enhancements to the privacy and efficiency of the
scripting system. It also opens up doors for things like [Scriptless
Script](http://hongchao.me/scriptless-script/), which leverages
Schnorr signature's algebra capability to capture the semantics of a
class of offchain protocols and only use the blockchain for
verification. Zero knowledge proof could also be a promising
future direction since in theory it can be constructed for
arbitrary computation offchain and then get verified onchain, one
demonstration is [Greg Maxwell](https://github.com/gmaxwell)'s
[ZKCP](https://bitcoincore.org/en/2016/02/26/zero-knowledge-contingent-payments-announcement/).
On the other hand, Ethereum lead the way to an array of Blockchains
that offer turning complete programming capabilities. The idea is to
express any sort of programs easily and get them executed on all the nodes in
the network which make them hard to stop. This expressiveness does come
with many tradeoffs: A fee model now needs to be developed to measure the
computational resources that a program consumes and charge it
accordingly. As a general purpose platform for deploying
[dApps](https://en.wikipedia.org/wiki/Decentralized_application),
the blockchain is usually much bigger, affecting its scalability and
decentralization properties. Turing complete languages can also
potentially open up much larger attack surface than a more limiting
language which is relatively easier to reason
about. Neverthelss, dApps platforms have certainly attracted a
lot of the developer mindshare and we start to see applications
especially in the [DeFi](https://www.binance.vision/glossary/defi)
space start to gain momentum.

Crypto also offers a set of unique challenges when it comes to
**software engineering**. Deploying software updates in a decentralized
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

Of course, the basic research of **cryptography**, which is one of the
building blocks of blockchain, has also seen a lot of progress because
of the emergance of the crypto industry in the past 10 years. More
types of zero knowledge proofs and their efficient applications are
being developed, aiming to improve both the privacy and scalability of
the blockchain system. [Multi-party
computation](https://en.wikipedia.org/wiki/Secure_multi-party_computation)
is also an vibrant research area which could be leveraged to design
secure protocols that encode complex interactions among many
participants offchain and simplify the corresponding smart contracts
onchain. Recent advancement to [Post-quantum
cryptography](https://en.wikipedia.org/wiki/Post-quantum_cryptography)
is also something worth looking into.

This is just a tip of an iceberg. An interesting properties of crypto is
that it is so multi-disciplinary that even a seemingly pure technical
change might trigger butterfly effect and result in significant
consequences, which makes the problem extremely challenging.

### Grand Vision
world needs alternative, needs asynmmetric tech, needs a way to say
no, finance and data and the. needs censorship resistence.

### Finance



### The need for alternatives

already the biggest PKI infra deployed
counter for Big Corp data thing



finance the unbanked
liberty 
crypto punks
freedom

### Self sovereignty
low time preference, saving, invest into the future


