---
layout: post
category: Bitcoin, Cryptocurrency, Cryptography
title: Scriptless Script
---

[Mimblewimble](https://github.com/mimblewimble/grin/blob/master/doc/intro.md) brought a lot of excitement within the industry. It leverages
[confidential transaction](https://people.xiph.org/~greg/confidential_values.txt) which improves privacy and fungibility by hiding transaction amounts
using [pedersen commitment](https://www.getmonero.org/resources/moneropedia/pedersen-commitment.html).
A key observation is that the blinding factor contained in the pedersen commitment can also be used to represent ownership of the coin.
This turns out to be great for scalability and a further boost to privacy since the blockchain can then be reduced into a very compact form via the mechanism of
[cut-through](https://github.com/mimblewimble/grin/blob/master/doc/intro.md#cut-through), which is the key differentiator between Mimblewimble based
coins and other privacy coins.

Unlike many other cryptocurrency systems where the ownership of the coin is determined by the successful execution of a
[smart contract](https://en.wikipedia.org/wiki/Smart_contract), the claim for a Mimblewimble based coin is solely depenent on if a verifiable signature can be
provided for the [kernel execess](https://github.com/mimblewimble/grin/blob/master/doc/intro.md#transaction-aggregation),
which is the public key deduced from the blinding factors that represents the ownership of the coin. Mimblewimble doesn't natively support any smart contract languages.

This feels quite limiting since the ability to write smart contracts could significantly enhance the usefulness of a blockchain, one great example is
[lightning network](https://en.wikipedia.org/wiki/Lightning_Network).

====== draft ======

and means that Miḿbilewimble doesn't natively support any smart contract language, , there doesn't seem to be an obvious way to write smart contract since there doesn't even exist a smart contract language.

One of the
key characteristics of Mimblewimble is that it not only leverages 
but also uses the blinding factor in CT's  to represent
ownership of the coin. 


The idea of scriptless script originated from trying to figure out how to write smart contract in Mimblewimble.


How to build up this article

Schnorr signatures

how to generalize a common thing, what does it capture

a few examples of how it is used.





taproot sort of hides some kind of contract directly in any signature



then what can we do with it?

Schnorr signature is a very much anticipated feature within the Bitcoin community. 

signature aggregation

benefit (fungibility, scriptless script)

downside

discussion in the community

reference: https://www.youtube.com/watch?v=PDzGP621pEs (from 33)

rogue key attack, the last person controls the key
https://bitcointechtalk.com/scaling-bitcoin-schnorr-signatures-abe3b5c275d1