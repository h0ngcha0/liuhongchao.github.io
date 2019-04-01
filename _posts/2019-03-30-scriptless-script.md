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
in a Mimblewimble transaction to ensure that the sum of inputs and outputs's amounts commitment adds up to zero). Signature of a kernel excess is the only way to represent
ownership in Mimblewimble, therefore no smart contract languages are needed. Even if smart contracts exist in some of the transactions,
it will be hard for public verifiers to verify them since the cut through mechanism would make many of them disappear.

This does feel quite limiting since the ability to write smart contracts significantly increases the usefulness of the blockchain,
[lightning network](https://en.wikipedia.org/wiki/Lightning_Network) is one great example of that. To solve this problem, [Andrew Poelstra](https://github.com/apoelstra)
invented scriptless script which embeds smart contracts into digital signatures so that they could not only represent the authorization of simple coin movements but
also the successful execution of the more complex logic such as multi-sig, atomic swap and even timelocks. As it turns out, this technology is not Mimblewimble
specific and could be used to improve the privacy, efficieny and scalability of other blockchains as well, including Bitcoin.

Before diving more into details, let's talk a little bit about [Schnorr Signatures](https://en.wikipedia.org/wiki/Schnorr_signature) since within this scheme scriptless script
is much easier to reason about even though it is also [possible](http://diyhpl.us/wiki/transcripts/scalingbitcoin/tokyo-2018/scriptless-ecdsa/)
to do it in ECDSA too.

#### Schnorr Signatures

In systems like Bitcoin and Ethereum, signature construction and verification is currently done through [ECDSA](https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm),
which was designed as a variant of Schnorr Signature to avoid its parent issues. Even though the patent expired in 2008, shortly before Bitcoin was invented, ECDSA was much more standardized
at the time as the result of it. From the technical point of view, it doesn't seem to have any other merits for Bitcoin to choose it over Schnorr Signatures.

One of the biggest advantages of Schnorr Signature over ECDSA is linearity, which basically means that multiple schnorr signatures signed by different private keys for the same message can be verified by
the sum of all their corresponding public keys. To understand how it works, we need to understand how a digital signature is constructed and verified with both ECDSA and Schnorr Signatures.

Let's say we have a keypair **(x, P)** where **P = xG** (**G** represents the [generetor](https://bitcoin.stackexchange.com/questions/29904/what-exactly-is-generator-g-in-bitcoins-elliptical-curve-algorithm)). To
sign a message, first of all an ephemeral keypair **(k, R)** where **R = kG** needs to be generated. Assuming that the message to be signed is **m**, in case of Schnorr, the signature would look something
like this:

{% highlight Haskell %}
signature = (s, R)
  where
    s = k + ex
    e = H(P||R||m)
{% endhighlight %}

**e** is the hash commitment to the concatenation of **P**, **R** and **m**, all of which are public information. To check this signature, mutliple **G** on both sides of **s = k + ex** and verify that
the equation holds.

{% highlight Haskell %}
sG = kG + exG   -- k and x are private variables
   = R + eP     -- all variables are public
   where
     e = H(P||R||m)
{% endhighlight %}

Assuming that two parties (Alice and Bob) want to sign the same message together (multi-sig), and their keypairs are **(xa, Pa)** and **(xb, Pb)** respectively. Alice needs to generate an ephemeral
keypair **(ka, Ra)** and Bob needs to generate his **(kb, Rb)** as well. Before signing, they exchange the public key part of their ephemeral keypair **Ra** and **Rb** to each other and construct individual
signatures:

{% highlight Haskell %}
signatureAlice = (sa, Ra)
  where
    sa = ka + ex
    e  = H(P||R||m)
    P  = Pa + Pb
    R  = Ra + Rb
    
signatureBob = (sb, Rb)
  where
    sb = kb + ex
    e  = H(P||R||m)
    P  = Pa + Pb
    R  = Ra + Rb
{% endhighlight %}

The multi-sig signature **(s, R)** would just be the addition of signatureAlice and signatureBob: **(sa+sb, Ra+Rb)** and it will verify correctly with the addition of the public key **P (P=Pa+Pb)** as shown
below:

{% highlight Haskell %}
sG = saG + sbG
   = (sa + sb)G
   = (ka + kb)G + e(xa + xb)G  -- ka, kb, xa and xb are private variables
   = Ra + Rb + e(Pa + Pb)      -- all variables are public
   = R + eP
   where
     e = H(P||R||m)
{% endhighlight %}

This property is called linearity, which means that with Schnorr, multi-sig signatures can be aggregated into one single signature and verifiers would have no idea whether this signature is the result of a complex interaction between multiple participants
or just one user unlocking a single public key, a great win for both privcy and efficiency. Note that in practice multi-sig is constructed in a [more complex way](https://blockstream.com/2019/02/18/en-musig-a-new-multisignature-standard/) due to the
possibility of [rogue key attack](https://eprint.iacr.org/2018/417.pdf), but the essence remains the same.

This nice linearity property doesn't hold for ECDSA since with the same keypairs, the formula for signature **(s, R)** looks something like this:

{% highlight Haskell %}
-- ECDSA signature construction
signature = (s, R)
  where
    sk = R' + ex  -- sk multiplication breaks linearity
    e = H(m)
    R' = x coordinator of R on the elliptic curve

-- ECDSA signature verification, multiply G on both sides
skG = R'G + exG   -- k, x are private variables
sR  = R'G + eP    -- all variables are public
{% endhighlight %}

If Alice and Bob go through the same process described above to construct a multi-sig signature using ECDSA, the result can no longer be verified by the addition of their public keys. Linearity is broken by the
multiplication **s*k**.

The fact that we could express some kind of logic (multi-sig) in one single schnorr signature is interesting. It is in line with the goal of scriptless script: embed interesting logic in signatures and keep
it indistinguishable from the rest of the world. In this sense, it should be considered as one form of scriptless script. To help express more complex logic using scriptless script, [Andrew Poelstra](https://github.com/apoelstra)
invented a way to piggyback a piece of secret in a signature, called Adaptor Signatures.

#### Adaptor Signatures

Is schnorr multi-sig an special case for adaptor signature? no, perhpas not. Adatpor signature allows you to sell a piece of secret information while completing the transaction (signing a secret). this allows a bunch of
use cases, such as atomic swaps

#### Scriptless Script

============ draft ================== draft ==================

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

reference of schnorr signature math
ECDSA is not linear. Schnorr is: the signature verification equation
is sG = R + H(R,P,m)*P. Two people can come up with their own R1 and
R2, and if they then produce signatures s1 and s2 that satisfy the
equation s1G = R1 + H(R1+R2,P,m)*P1, and then add up s = s1 + s2, the
result satisfies sG = R + H(R,P,M)(P1+P2); i.e. it's a valid signature
for the sum of the keys. Such a construction is only possible due to
the equation being linear in all signer variables: s = k + H(R,P,m)x
(with k = nonce, x = private key). For ECDSA it is sk = m + rx. The
multiplication s*k breaks linearity.
https://bitcoin.stackexchange.com/questions/77234/schnorr-vs-ecdsa