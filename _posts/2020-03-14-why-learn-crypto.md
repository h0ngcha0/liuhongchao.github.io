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
certain amount of higher dimensional insights which most of us simply
do not pocess. Surprisingly, I wasn't that much emotionally affected
by the price this time like the roller coaster feeling I got from
2017 to 2018. In retrospect, I think it has to do with the fact that
over the years my grown appreciation to the crypto space (primarily
Bitcoin) makes it much more than just a financial investment. (but a window..)

Blockchain is facinating from the technical perspective. It was
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
are creating.

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

There are also a set of difficult technical challenges in the crypto
space. 



