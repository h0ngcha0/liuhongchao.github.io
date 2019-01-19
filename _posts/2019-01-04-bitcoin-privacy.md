---
layout: post
category: Fintech, Blockchain, Philosophy, Privacy
title: Privacy of Bitcoin
---

Bitcoin whitepaper has a [section dedicated to privacy](https://nakamotoinstitute.org/bitcoin/#privacy), in which it states:

> The traditional banking model achieves a level of privacy by limiting access to information to the
> parties involved and the trusted third party. The necessity to announce all transactions publicly
> precludes this method, but privacy can still be maintained by breaking the flow of information in
> another place: by keeping public keys anonymous.

Conceptually, a bitcoin transaction consists of 4 pieces of sensitive information: sender, reciever, amount and the
logic with which the old [TXO](https://en.bitcoin.it/wiki/Transaction#Output) was spent and the new [TXO](https://en.bitcoin.it/wiki/Transaction#Output)
is intended to be spent. When transactions are broadcasted to the Bitcoin network, all of those information is
unprotected because [the only way to confirm the absence of a transaction is to be aware of all transactions](https://twitter.com/francispouliot_/status/1075414899235409920).
One can question if making all aspects of a transaction transparent to the public is the only way (or even the best way)
to "be aware" of it, but the fact that all transactions are transparent in the Bitcoin blockchain means that if Alice's
real life identity is somehow tied a Bitcoin address, she will lose the privacy of all her past and future transactions
associated with that address.

Most of the privacy technologies in the space are designed to obfuscate one or more of transaction's sensitive information 
from the blockchain. Before diving into details, a few things should perhaps also be taken into account when evaluating
privacy technologies.

* First, there seems to a tension between privacy and decentralization. Due to the public permissionless nature of the blockchain, traditional
banks arguably maintain better privacy than Bitcoin for majority of their users as long as they are
technically and ethnically trusted to be reliable custodians. Whether a privacy enhancing technology comes at a cost of centralization is worth considering.
* Privacy and scalability don't always play well together. Many privacy enhancing technologies require heavier computation and
more storage which gets magnified dramatically in the context of blockchain, affecting it's ability to scale.
* Privacy technologies sometimes negatively impact user experience. Transaction signing and verification might take unreasonable amount of time
and resources. Sometimes interaction with other users is required, which just adds an extra burden in terms of usibility.
No matter how perfect a privacy technology is on paper, it doesn't generate any real world value if nobody uses it.

### Receiver

#### New address for new payment
Assuming Alice uses an unique Bitcoin address all the time and this address somehow gets tied back to her real world identity,
Alice's entire transaction history on Bitcoin network will become public. One way to mitigate this problem is to
generate a fresh receiving address for each incoming transactions, which is a pretty safe and easy operation if Alice uses
one of those [HD](https://en.bitcoin.it/wiki/Deterministic_wallet) wallets. This way, to piece together Alice's transaction history,
attackers need to tie all of those addresses together to Alice's identity, which is
[not impossible](https://cseweb.ucsd.edu/~smeiklejohn/files/imc13.pdf) but significantly harder. In fact, use new address to receive
this payment is [a best practice](https://bitcoin.org/en/protect-your-privacy#receive) when using bitcoin.

#### Stealth address
In scenarios such as TV or billboard ads, where generating a fresh receiving address is not an option, stealth address might offer a solution.
The idea is that after Alice publishes her public key, whoever wants to pay her needs to take that information, generate and
"pay" to a new public key whose corresponding private key can only be derived by Alice. One way to achieve this is by leveraging the
[ECDH](https://en.wikipedia.org/wiki/Elliptic-curve_Diffie%E2%80%93Hellman) protocol.

Assuming that Alice's keypair is **A=aG** where **G** is the base point of an [Eliptic Curve](https://en.wikipedia.org/wiki/Elliptic-curve_cryptography),
Bob first needs to generate a ephemeral keypair **B=bG**. With [ECDH](https://en.wikipedia.org/wiki/Elliptic-curve_Diffie%E2%80%93Hellman) protocol,
the shared secrets between Alice and Bob is **secret=bA=aB=abG**. Bob then pays to the new address derived from **A+H(secret)G** where **H** is a
cryptographic hash function. Since only Alice knows **a+H(secret)**, she is the only one who can spend the fund in this new address.

In reality, as [described](https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2014-January/004020.html)
by Bitcoin developer Peter Todd, it requires Bob to make an extra transaction with **OP_RETURN** to essentially communicate the ephemeral
public key *B* to Alice so that she can derive the shared secret. But [according to him](https://www.reddit.com/r/Bitcoin/comments/5xm9bt/what_happened_to_stealth_addresses/dejcjmw)
later on, **OP_RETURN** was changed at last minute to only include 40 bytes of data, so the stealth address BIP (BIP 63) was never published. Overall, stealth address
is not well adopted in the Bitcoin ecosystem. However, other cryptocurrencies such as [Monero](https://www.getmonero.org) and [TokenPay](https://www.tokenpay.com/)
implements a [more interesting version of stealth address](https://src.getmonero.org/resources/moneropedia/stealthaddress.html) which enables the seperation of view key
and spend key by utilizing the [Dual-Key Stealth Address Protocol](https://medium.com/tokenpay/tokenpay-utilizes-dual-key-stealth-addresses-for-complete-anonymity-c5ae682ce879).
This is very useful when transaction history need to be inspected by third parties without giving them the ability to spend the fund.

#### Resusable payment code
(BIP 47? Resusable payment code)

### Sender

To obfuscate the sender of a transaction, the general idea is to hide it among other senders or decoys and make it hard for the attacker to
figure out which one actually sends the fund to your receiver.

<img src="{{ site.baseurl }}/images/crowd-of-people-images-crowd.jpg" alt="crowd-anonymous" style="width: 500px;"/>

#### Centralized Mixer (aka Tumbler)

One approach is to utilize the [centralized mixing services](https://en.bitcoin.it/wiki/Mixing_service). Essentially funds are sent to a mixer which
then gets mixed with other users' funds and/or mixer's own funds. If the mixer is well-intentioned, hopefully equal amount of funds (minus service fee) will be sent
back to the users at new addresses. This idea is pretty straight forward, but there are a lot of pitfalls when it comes to the actual implementations. One example
is that if the amount of all the [TXO](https://en.bitcoin.it/wiki/Transaction#Output)s to be mixed are different, it will serve as an extra piece of information to reveal
who the sender is. Therefore it is advised to mix transactions with standard chunk sizes. Section **6.3 Mixing** of the execellent book
[Bitcoin and Blockchain Technologies](https://d28rh4a8wq0iu5.cloudfront.net/bitcointech/readings/princeton_bitcoin_book.pdf) discusses some of the potential
implementation issues with centralized mixers at length, including a set of guidelines for them to provider better quality services for their users.

However, the fact that it is centralized means that it suffers the
same set of problems as banks or centralized exchanges. Mixers could potentially steal users' funds. It might retain the ability to trace
back where certain fund is originated. Mixing large amount of funds [may be illegal](https://en.wikipedia.org/wiki/Cryptocurrency_tumbler#Background)
in some jurisdictions, having a liable central entity might pose a larger regulatory risk. Also, mixing large amount of funds might take
a long time, which hurts usability.

Still, centralized mixers such as [bestmixer.io](https://bestmixer.io/en) might be useful for people with certain threat models and risk profiles. 

#### Coinjoin


#### Tumblebit
#### ZeroLink
#### Ring signatures
#### Ring CT

### Amount

### Spending conditions (smart contract)



transaction amount, transaction 

There are a few privacy enhacing features we would like Bitcoin to have 

Bitcoin left many clues on the 

Left too much clues.

From the user's perspective.
who you are, what you buy, how much?


Analyze how people can analyze Bitcoin transactions and reach to the conclusion that there are a number of things that
needs to be hidden.

What are the information that we wanna hide in Bitcoin? Few things that we wanna hide in Bitcoin transactions are 

- Transaction Graph (all the mixing technologies, breaking the transaction trail)
- Amount (confidential transactions, zero knowledge proof)
- Address (stealth addresses)
- Sender and receiver (but that is part of the transaction graph)

- blind signatures

- At the network layer, Dandelion


What is offered by built in best practices

What is not private?

We need to break down when transaction has to be made public, what are the elements that could be hidden to
make them still be public but pretty high privacy

transaction graph
address?
stealth address?
amount still available (graph, side channel)
sender and receiver

anonymity set

Banks protect privacy of their customers through access control. 

Bitcoin is [pseudonymous](https://en.wikipedia.org/wiki/Pseudonymity), real world identities are not
explicitly tied to bitcoin addresses. 

Satoshi Nakamoto famously wrote in the Bitcoin whitepaper that
*The only way to confirm the absence of a transaction is to be aware of all transactions*. 



Define privacy, "three area", and research past, present and future technologies that
has implication to bitcoin's privacy, 

how those technologies affect other stuff such as scalability, etc


privacy easily used.
bulletproof for monaro
sapling for zcash