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

### Schnorr Signatures

In systems like Bitcoin and Ethereum, signature construction and verification is currently done through [ECDSA](https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm),
which was designed as a variant of Schnorr Signature to avoid its parent issues. Even though the patent expired in 2008, shortly before Bitcoin was invented, ECDSA was much more standardized
at the time as the result of it. From the technical point of view, it doesn't seem to have any other merits for Bitcoin to choose it over Schnorr Signatures.

One of the biggest advantages of Schnorr Signature over ECDSA is linearity, which basically means that multiple schnorr signatures signed by different private keys for the same message can be verified by
the sum of all their corresponding public keys. To understand how it works, we need to understand how a digital signature is constructed and verified with both ECDSA and Schnorr Signatures.

Let's say we have a keypair **(*x*, P)** where **P = *x*G** (**G** represents the [generetor](https://bitcoin.stackexchange.com/questions/29904/what-exactly-is-generator-g-in-bitcoins-elliptical-curve-algorithm)). To
sign a message, first of all an ephemeral keypair **(*k*, R)** where **R = *k*G** needs to be generated. Assuming that the message to be signed is **m**, in case of Schnorr, the signature would look something
like this:

{% highlight Haskell %}
signature = (s, R)
  where
    s = k + ex
    e = H(P||R||m)
{% endhighlight %}

**e** is the hash commitment to the concatenation of **P**, **R** and **m**, all of which are public information. To check this signature, mutliple **G** on both sides of **s = *k* + e*x*** and verify that
the equation holds.

{% highlight Haskell %}
sG = kG + exG   -- k and x are private variables
   = R + eP     -- all variables are public
   where
     e = H(P||R||m)
{% endhighlight %}

Assuming that two parties (Alice and Bob) want to sign the same message together (multi-sig), and their keypairs are **(*xa*, Pa)** and **(*xb*, Pb)** respectively. Alice needs to generate an ephemeral
keypair **(*ka*, Ra)** and Bob needs to generate his **(*kb*, Rb)** as well. Before signing, they exchange the public key part of their ephemeral keypair **Ra** and **Rb** to each other and construct individual
signatures:

{% highlight Haskell %}
signatureAlice = (sa, Ra)
  where
    sa = ka + exa
    e  = H(P||R||m)
    P  = Pa + Pb
    R  = Ra + Rb
    
signatureBob = (sb, Rb)
  where
    sb = kb + exb
    e  = H(P||R||m)
    P  = Pa + Pb
    R  = Ra + Rb
{% endhighlight %}

The multi-sig signature **(*s*, R)** would just be the addition of signatureAlice and signatureBob: **(*sa*+*sb*, Ra+Rb)** and it will verify correctly with the addition of the public key **P (P=Pa+Pb)** as shown
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

It is also worth noting that a proof exists that as long as the underlying [elliptic curve cryptography](https://en.wikipedia.org/wiki/Elliptic-curve_cryptography) works, Schnorr signatures
are secure, but there wasn't a similiar mathematical proof for ECDSA yet.

The fact that we could reduce some kind of logic (multi-sig) into one single schnorr signature is interesting. It could be considered as a type of scriptless script since it is in line with its design goal:
*embed interesting logic in signatures and keep it indistinguishable from the rest of the world*. A simple multi-sig essentially utilized the ability to perform additions on Schnorr Signatures,
[Andrew Poelstra](https://github.com/apoelstra) also realized that the subsctraction on it can be leveraged to piggyback a piece of secret information which could enable expressing more complex logic.
That is the idea behind Adapter Signatures.

### Adaptor Signatures

Adaptor signatures is designed to communicate an extra piece of secret information between two parties through multi-sig. Remember that Alice and Bob need to exchange the public side of the ephemeral
keypair **Ra** and **Rb** before a joint aggregated multi-sig is created. If Bob also wants to sell a piece of secret information ***tb*** to Alice, the idea is that he can create
an extra ephemeral keypair **(*tb*, Tb)** where **Tb=*tb*G** and communicate **Tb** to Alice alongside **Rb**. Right now, Bob is able to create a valid signature that includes
**(*tb*, Tb)**:

{% highlight Haskell %}
bobSignature = (sb, R, Tb)
  where
    sb = kb + tb + ex
    e  = H(P||R+Tb||m)
    P  = Pa + Pb
    R  = Ra + Rb
{% endhighlight %}

***tb*** is called an adaptor and it offsets the value ***kb*** a little bit. If we substract ***tb*** from ***sb***, what we get is called an adaptor signature:

{% highlight Haskell %}
sb' = kb + ex
    = sb - tb
  where
    e = H(P||R+Tb||m)
    P = Pa + Pb
    R = Ra + Rb
{% endhighlight %}

If Bob sends **sb'** to Alice, Alice can verify three things:

{% highlight Haskell %}

-- 1) sb' is not a valid signature, since Tb is added to R
sb' = kb + ex
  where
    e = H(P||R+Tb||m)
    P = Pa + Pb
    R = Ra + Rb

-- 2) if e is replaced with e', then sb' is a valid signature
sb' = kb + e'x
  where
    e' = H(P||R||m)
    P = Pa + Pb
    R = Ra + Rb

-- 3) Tb's secret key tb is needed for a valid signature sb
sb = sb' + tb = kb + tb + ex
  where
    e = H(P||R+Tb||m)
    P = Pa + Pb
    R = Ra + Rb

{% endhighlight %}

Number 3) gives Alice the confidence that if she somehow learns **sb**, she will learn **Tb**'s secret key ***tb*** by substracting **sb'** from **sb**. She then feels
comfortable to send her coin to a multi-sig address jointly owned by **Pa** and **Pb**, along with her signature (in reality, Bob might disappear, so it's important for Alice
to have recourse to that, but that is not interesting for this discussion):

{% highlight Haskell %}

signatureAlice = (sa, R, Tb)
  where
    sa = ka + exa
    e  = H(P||R+Tb||m)
    P = Pa + Pb
    R  = Ra + Rb

-- created by Bob to take the coin from the multi-sig address
signatureJointMultiSig = (s, R, Tb)
  where
    s = sa + sb
      = sa + sb' + tb
    R = Ra + Rb

{% endhighlight %}

Using **signatureAlice**, Bob can create **signatureJointMultiSig** and use it to take the coin from the jointly owned multi-sig address that Alice just paid. As soon as
**signatureJointMultiSig** hits the blockchain, secret ***tb*** is automatically revealed to Alice with the simple formula of **tb = s - sa - sb'** in a trustless manner.

#### Zero Knowledge Contigent Payment
One might wonder how useful is it to buy a secret this way. It turns out that if we can prove this secret is the solution to
an interesting problem without revealing the secret beforehand (using [zero knowledge proof](https://en.wikipedia.org/wiki/Zero-knowledge_proof)), it might open
up a lot of applications. This protocol is called [zero knowledge contigent payment](https://en.bitcoin.it/wiki/Zero_Knowledge_Contingent_Payment) and is commonly expressed
in Bitcoin as hash-locked transactions. The advantage of using adaptor signatures instead is that the resulting transaction is completely indistinguishable from any other transactions,
providing much greater fungibility, privacy and efficiency. It also offers a way for systems like Mimblewimble to achieve the similiar functionalities without requring a
[Script](https://en.bitcoin.it/wiki/Script) like language.

#### Atomic Swap

Alice and Bob can also use adaptor signatures to accomplish [atomic swap](https://www.investopedia.com/terms/a/atomic-swaps.asp) by executing essentially the same protocol
in parallel on two chains.

Let's say **ChainA** and **ChainB** use the same elliptic curve (e.g. [secp256k1](https://en.bitcoin.it/wiki/Secp256k1)). Alice and Bob agree to swap Alice's coin on **ChainA**
with Bob's coin on **ChainB** in a trustless and atomic way. Assuming that Alice and Bob's keypair is **(*xa_A*, Pa_A)** and **(*xb_A*, Pb_A)** on **ChainA** and
**(*xa_B*, Pa_B)** and **(*xb_B*, Pb_B)** on **ChainB** respectively. First of all, Alice's coin will be paid to a multi-sig address controlled by **Pa_A** and **Pb_A** on **ChainA** while
Bob's coin will be paid to a multi-sig address controlled by **Pa_B** and **Pb_B** on **ChainB**. The mechanism for getting refund when counterparty disappears is intentionally ignored
here for brevity.

Next, Alice and Bob exchange the ephemeral keypairs on both chains, to follow the same convention, **(*ka_A*, Ra_A)**, **(*kb_A*, Rb_A)** on **ChainA** and **(*ka_B*, Ra_B)**,
**(*kb_B*, Rb_B)** on **ChainB**. On top of that, Bob generates an extra ephemeral keypair **(*tb*, Tb)** and share it with Alice on both chains. Bob's signature could eventually
look something like this:

{% highlight Haskell %}
bobSignatureChainA = (sb_A, R_A, Tb)
  where
    sb_A = kb_A + tb + e_Axb_A
    e_A  = H(P_A||R_A+Tb||m)
    P_A  = Pa_A + Pb_A
    R_A  = Ra_A + Rb_A

bobSignatureChainB = (sb_B, R_B, Tb)
  where
    sb_B = kb_B + tb + e_Bxb_B
    e_B  = H(P_B||R_B+Tb||m)
    P_B  = Pa_B + Pb_B
    R_B  = Ra_B + Rb_B
{% endhighlight %}

However, just like what Bob did before, he sends Alice his adaptor signatures **sb_A' = *kb_A* + e_A*xb_A*** and **sb_B' = *kb_B* + e_B*xb_B*** for her to verify. After Alice feels confident
that **Tb**'s secret key ***tb*** is the one needed to get **sb_A** and **sb_B** from **sb_A'** and **sb_B'**, she sends her part of the multi-sig signature on ChainA to Bob:

{% highlight Haskell %}
aliceSignatureChainA = (sa_A, R_A, Tb)
  where
    sa_A = ka_A + e_Axa_A
    e_A  = H(P_A||R_A+Tb||m)
    P_A  = Pa_A + Pb_A
    R_A  = Ra_A + Rb_A
{% endhighlight %}

Bob can produce an aggregated signature **signatureJointMultiSigChainA** by combining **aliceSignatureChainA** and **bobSignatureChainA** to take Alice's coin on ChainA, as shown below:

{% highlight Haskell %}
signatureJointMultiSigChainA = (s_A, R_A, Tb)
  where
    s_A = sa_A + sb_A
        = sa_A + sb_A' + tb
    R_A = Ra_A + Rb_A
{% endhighlight %}

At the same time, knowing **sb_A'**, Alice can calculate the secret value ***tb*** by substracting **sa_A** and **sb_A'** from **s_A**. Since Alice also knows **sb_B'**, she can also use ***tb***
to calculate a valid joint signature **signatureJointMultiSigChainB** on ChainB to take Bob's coin, accomplishing the process of [atomic swap](https://www.investopedia.com/terms/a/atomic-swaps.asp).

{% highlight Haskell %}
aliceSignatureChainB = (sa_B, R_B, Tb)
  where
    sa_B = ka_B + e_Bxa_B
    e_B  = H(P_B||R_B+Tb||m)
    P_B  = Pa_B + Pb_B
    R_B  = Ra_B + Rb_B

signatureJointMultiSigChainB = (s_B, R_B, Tb)
  where
    s_B = sa_B + sb_B
        = sa_B + sb_B' + tb
    R_B = Ra_B + Rb_B
{% endhighlight %}

Again, from the perspective of the blockchain and the rest of the world, only simple signatures are involved in those transactions, greatly improves privay, fungibility and efficiency, 

<br/>

Scriptless script can be used to express other smart contracts as well. For example, [Jonas Nick](https://jonasnick.github.io/) presented
[a way](https://jonasnick.github.io/blog/2018/07/31/blind-signatures-in-scriptless-scripts/) of encoding blind signatures in scriptless script. Mimblewimble also maintains a list of
[contracts](https://github.com/mimblewimble/grin/blob/master/doc/contracts.md) that could potentially be implemented using some of the ideas from scriptless script. There are some open
questions too, notably how to encode timelocks and 3+ multiparties protocols.

Scriptless script can potentially take a class of smart contracts offchain, as long as their effect can be encoded in secret values and embedded in signatures. For those use cases,
blockchain becomes a mechanism to verify or enforce smart contracts instead of computing them, which is perhaps what a it [should do](https://bitcointalk.org/index.php?topic=1427885.msg14601127#msg14601127).
As a result, it can be a great win for efficiently, fungibility and privacy.

----

Reference:
- https://joinmarket.me/blog/blog/flipping-the-scriptless-script-on-schnorr/
- https://lists.linuxfoundation.org/pipermail/lightning-dev/2018-May/001297.html
- https://github.com/mimblewimble/grin/blob/master/doc/contracts.md
- https://github.com/apoelstra/scriptless-scripts/blob/master/md/atomic-swap.md
- https://bitcoin.stackexchange.com/questions/77234/schnorr-vs-ecdsa
- https://www.youtube.com/watch?v=PDzGP621pEs
