---
layout: post
category: Bitcoin, Cryptocurrency, Cryptography
title: Scriptless Script
---

[Mimblewimble](https://github.com/mimblewimble/grin/blob/master/doc/intro.md) brought a lot of excitement within the crypto industry. It leverages
[confidential transaction](https://people.xiph.org/~greg/confidential_values.txt) which improves privacy and fungibility by hiding transaction amounts
using [pedersen commitment](https://www.getmonero.org/resources/moneropedia/pedersen-commitment.html).
One key realization is that the blinding factor contained in the pedersen commitment can also be used to represent ownership of the coin.
This turns out to be great for scalability and a further boost to privacy since the blockchain can then be reduced to a very compact form with much less
information for third party analysis via a mechanism called [cut-through](https://github.com/mimblewimble/grin/blob/master/doc/intro.md#cut-through), which is the key differentiator between Mimblewimble based
coins and other privacy coins.

Unlike many other cryptocurrencies where the ownership of the coin is determined by the successful execution of a
[smart contract](https://en.wikipedia.org/wiki/Smart_contract), the claim for a Mimblewimble based coin is solely dependent on if a verifiable signature can be
provided for the [kernel execess](https://github.com/mimblewimble/grin/blob/master/doc/intro.md#transaction-aggregation),
which is the public key derived from the sum of outputs' blinding factors minus the sum of inputs' blinding factors (in practice, it is added as an extra zero-valued output
in a Mimblewimble transaction to ensure that the sum of inputs and outputs's amounts commitment adds up to zero). Kernel excess is the only way to represent
the ownership of the coin in Mimblewimble, therefore no smart contract languages are needed. More over, even if smart contracts exist in some of the transactions,
it will be hard for public verifiers to verify them since the cut through mechanism would make many of them disappear.

This does feel quite limiting since the ability to write smart contracts significantly increases the usefulness of the blockchain,
[lightning network](https://en.wikipedia.org/wiki/Lightning_Network) is one great example of that. To solve this problem, [Andrew Poelstra](https://github.com/apoelstra)
invented scriptless script which embeds smart contracts into digital signatures so that they could not only represent the authorization of simple coin movements but
potentially also more complex logic such as multi-sig, atomic swap and even timelocks. As it turns out, this technology is not Mimblewimble
specific and could be used to improve the privacy, efficieny and scalability of other blockchains as well, including Bitcoin.

Before diving into details, let's talk a little bit about [Schnorr Signatures](https://en.wikipedia.org/wiki/Schnorr_signature) since within this scheme scriptless script
is much easier to reason about, even though it is also [possible](http://diyhpl.us/wiki/transcripts/scalingbitcoin/tokyo-2018/scriptless-ecdsa/)
to do it in ECDSA too.

#### Schnorr Signatures

In systems like Bitcoin and Ethereum, signature construction and verification is currently done through [ECDSA](https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm),
which was designed as a variant to avoid Schnorr Signature's parent issue. Even though the patent expired in 2008, shortly before Bitcoin was invented, ECDSA was much more standardized
at the time as the result of it. From the technical point of view, there ain't really any other reasons to choose ECDSA instead of Schnorr Signatures.

One of the biggest advantages of Schnorr Signature over ECDSA is linearity, which basically means that multiple schnorr signatures signed by different private keys for the same message can be verified by
the sum of all their corresponding public keys. To understand how it works, we need to understand how a digital signature is constructed and verified in both ECDSA and Schnorr Signatures.

Assuming we have a keypair `(x, P)` where `P = xG`.


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

is the curve different between ecdsa and schnorr?

can scriptless script be done on ECDSA?
https://lists.linuxfoundation.org/pipermail/lightning-dev/2018-May/001297.html


so in a way mimblewimble's kernel signature proves the ownership, what if the signature can contain other data?
"scriptless script" is a way to use these kernels and kernel signatures to attach conditions to them without
modifying the system so that the verifiers need to understand new rules

so mimblewimble is a special case for scriptless script since it kind of represents a multi-sig.

if a signature can faithfully record the outcome of executing a protocol, then it could be expressed using
scriptless script.

how the taproot story is reconciled with scriptless script.

hard to do multi-party adaptive signature. signature aggregation breaks this.

witness encryption??? moon math, allow doing timelock stuff, do not understand.

discuss some contracts. e.g. timelock, atomic swap, multi-sig

open problems
"That's it, that's the end of my talk. Let's figure out timelocks, scriptless scsripts with BLS, and multiparty 3+ party scriptless scripts. And what about standards and interoperability."

kernel is a zero valued output

maybe say something about bitcoin might want this CT property since compared to pure math, elliptic curve algebra is still not as strong.