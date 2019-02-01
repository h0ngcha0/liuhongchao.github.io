---
layout: post
category: Fintech, Blockchain, Philosophy, Privacy
title: Monero
---

#### Ring signatures

It is worth mentioning [ring signature](https://en.wikipedia.org/wiki/Ring_signature) here even though then chance of applying it to Bitcoin is almost zero. It is an interesting digital
signature scheme that can be used to implement a decentralized mixing service that requires no user interactions.

It is easy to verify that a ring signature is created by one of the members in a group but computationally infeasible to determine which one exactly. [CryptoNotes](https://cryptonote.org/coins)
based cryptocurrencies such as [Monero](https://ww.getmonero.org) takes advantage of this property to hide the senders
of transactions. When constructing a transaction, currently [10](https://github.com/wownero/meta/issues/11) spent outputs are ["randomly selected"](https://www.youtube.com/watch?v=Sn44ahKxC1E) by Monero 
from the blockchain as decoys along side with the real output. It will then:

* Derive a [key image](https://monerodocs.org/cryptography/asymmetric/key-image/) from the real output
* Generate a ring signature from this group of outputs.

[Key image](https://monerodocs.org/cryptography/asymmetric/key-image/) is unique for the same output even if it is mixed with different set of decoys.
Monero blockchain keeps track of all the key images of the spent outputs to avoid double spends.
A valid ring signature means that one of the outputs in the group is authorized to be spent without revealing which one exactly.

Sender protection is considered to be the weakest part of Monero's privacy scheme since there are a few known issues with ring signature such as
[0 decoy and chain reaction](https://www.youtube.com/watch?v=1CfXHC2IFx4), potential privacy breach during [hard fork](https://www.youtube.com/watch?v=6CVcirD90pg), etc.
When it comes to [decoys selection](https://www.youtube.com/watch?v=Sn44ahKxC1E&t=1s) it is usually a cats and mouse game because it is very hard to predict all the heuristics.
Nonetheless, it is still considered to be a technology that offers one of the strongest sender protection.
