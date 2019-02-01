---
layout: post
category: Fintech, Blockchain, Philosophy, Privacy
title: A Survey of Bitcoin Privacy Technologies
---

<img src="{{ site.baseurl }}/images/crowd-of-people-images-crowd.jpg" alt="crowd-anonymous" style="width: 500px;"/>

Bitcoin whitepaper has a [section dedicated to privacy](https://nakamotoinstitute.org/bitcoin/#privacy), in which it states:

> The traditional banking model achieves a level of privacy by limiting access to information to the
> parties involved and the trusted third party. The necessity to announce all transactions publicly
> precludes this method, but privacy can still be maintained by breaking the flow of information in
> another place: by keeping public keys anonymous.

A bitcoin transaction consists of 4 pieces of sensitive information: sender, reciever, amount and transaction logic
(written in [Bitcoin Script](https://en.bitcoin.it/wiki/Script)). When transactions are broadcasted to the Bitcoin network, all of those information is
unprotected because Satoshi believes that [the only way to confirm the absence of a transaction is to be aware of all transactions](https://twitter.com/francispouliot_/status/1075414899235409920).
It is debatable if recording all aspects of a transaction publicly forever is the only way (or even the best way)
to "be aware" of it, but the fact that all transactions are transparent in the Bitcoin blockchain means that if Alice's
real life identity is somehow tied a Bitcoin address, she will lose the privacy of all her past and future transactions
associated with that address.

Most of the privacy technologies are designed to obfuscate one or more of those 4 pieces of sensitive information 
from the blockchain, each making different set of tradeoffs. A few things should perhaps be considered when evaluating them.

* First, there seems to a tension between privacy and decentralization. Due to the public permissionless nature of the blockchain, traditional
banks can arguably maintain better transaction privacy than Bitcoin as long as they are
technically and ethnically trusted. It is important to evaluate if a privacy enhancing technology comes at the cost of centralization.
* Privacy and scalability don't always play well together. Many privacy technologies require heavier computational resources which gets
dramatically magnified in the context of blockchain, affecting it's ability to scale.
* Privacy technologies sometimes damage user experience because computation and verification might take unreasonable amount of time
and resources, complex interaction with other users and the system might be required.
No matter how perfect a privacy technology is on paper, it doesn't generate any real world value if nobody uses it.

Network layer privacy technolgies such as [Dandelion](https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2017-September/015030.html) or
[Peer to Peer Encryption](https://github.com/bitcoin/bips/blob/master/bip-0151.mediawiki) are not discussed. Neither is the privacy benefits of
the [Layer 2](https://en.wikipedia.org/wiki/Bitcoin_scalability_problem#%22Layer_2%22_systems) systems.

### Receiver
#### Hierarchical Deterministic Wallets
Assuming Alice uses an unique Bitcoin address all the time and this address somehow gets tied back to her real world identity,
Alice's entire transaction history on Bitcoin network will become public. One way to mitigate this problem is to
generate a fresh receiving address for each incoming transactions, which is a pretty safe and easy operation if Alice uses
one of those [HD Wallets](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki). This way, to piece together Alice's transaction history,
attackers need to tie all of those addresses together to Alice's identity, which is
[not impossible](https://cseweb.ucsd.edu/~smeiklejohn/files/imc13.pdf) but significantly harder. In fact, use new address to receive
this payment is [a best practice](https://bitcoin.org/en/protect-your-privacy#receive) when using bitcoin, including change addresses.

#### Stealth Address
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
is not well adopted in the Bitcoin ecosystem, [DarkWallet](https://www.darkwallet.is) seems to [support it](https://github.com/darkwallet/darkwallet/blob/4c51dacacb8541305f1442ef7fa1628eb7c19a79/src/js/util/stealth.js)
but the project is not actively maintained any more. [Monero](https://www.getmonero.org) and [TokenPay](https://www.tokenpay.com/)
on the other hand introduced a [more interesting version of stealth address](https://src.getmonero.org/resources/moneropedia/stealthaddress.html) which enables the seperation of view key
and spend key by utilizing the [Dual-Key Stealth Address Protocol](https://medium.com/tokenpay/tokenpay-utilizes-dual-key-stealth-addresses-for-complete-anonymity-c5ae682ce879).
This is very useful when transaction history need to be inspected by third parties without giving them the ability to spend the fund.

#### Resusable Payment Code
[Resumable Payment Code](https://github.com/bitcoin/bips/blob/master/bip-0047.mediawiki) protocol tries to achieve the same result as Stealth Address using the combination of
[ECDH](https://en.wikipedia.org/wiki/Elliptic-curve_Diffie%E2%80%93Hellman) protocol and [HD Wallets](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki).

Assuming that Alice and Bob want to transact in a private manner without sending each other new addresses all the time, both of them can generate a
resuable payment code which is essentially [extended public key](https://bitcoin.org/en/glossary/extended-key) in the context of [HD Wallets](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki).
Alice communicates her payment code through a notification transaction to Bob first, and from that point on Alice and Bob shares a secret according to the same
[ECDH](https://en.wikipedia.org/wiki/Elliptic-curve_Diffie%E2%80%93Hellman) protocol used in Stealth Address.

With this shared secret and the resuable payment codes from each other, Alice and Bob could generate a new HD wallet respectively where they can only spend their own fund but both of them know how to derive
new addresses for each other. This essentially builds up a secret payment tunnel between themselves.

[Samourai](https://samouraiwallet.com) is one of the wallets that [support](https://samouraiwallet.com/bips) Reusable Payment Code.

#### Coin Control

If two outputs are spent by the same transaction, they usually belong to the same owner (except for e.g. [CoinJoin](https://bitcointalk.org/index.php?topic=279249.0) transactions).
If one of them happens to be tainted, the other one will be considered tainted as well. [Coin Control](https://bitcoin.stackexchange.com/questions/37486/what-does-bitcoin-cores-coin-control-features-do-and-how-do-i-use-it)
gives users the option to pick which combinations of outputs to use when constructing a transaction, which could reduce the chance of accidentally tainting outputs.

Many wallets supports the coin control feature, including the [Bitcoin Core wallet](https://github.com/bitcoin/bitcoin/tree/master/src/wallet).

### Sender

To obfuscate the sender of a transaction, the general idea is to hide it among other senders or decoys and make it hard for the attacker to
figure out which one actually sends the fund to your receiver.

The key observation in Bitcoin is that inputs and outputs in a transaction are independent of each other and there is no indication as to the linkage between inputs and outputs.
Therefore if mutiple users construct one single transaction with their respective inputs and outputs, their funds are effectively mixed.

<img src="{{ site.baseurl }}/images/coinjoin.png" alt="coinjoin" style="width: 550px;"/><br/>
<span class="image-label">Image from [https://bitcointalk.org/index.php?topic=279249.0](https://bitcointalk.org/index.php?topic=279249.0)</span>

As illustrated above, it is hard to know whether the first output of transaction 2 is paid by its second input or the combination of its first and third inputs.

#### Centralized Mixer (aka Tumbler)

One approach is to have [centralized mixing services](https://en.bitcoin.it/wiki/Mixing_service) taking funds from users and then mix them
with other users' funds and/or mixer's own funds. If the mixer is well-intentioned, hopefully equal amount of funds (minus service fee) will be sent
back to the users at new addresses. This idea is pretty straight forward, but its centralized nature means that it suffers the same set of problems as banks or centralized exchanges. Mixers could potentially
steal users' funds. It might also retain the ability to trace back where certain fund is originated. Mixing large amount of funds
[may be illegal](https://en.wikipedia.org/wiki/Cryptocurrency_tumbler#Background) in some jurisdictions, having a liable central entity might pose
a larger regulatory risk.

There are also a lot of pitfalls even if the mixers are assumably trustworthy. One example
is that if the amount of all the [TXO](https://en.bitcoin.it/wiki/Transaction#Output)s to be mixed are not the same, it becomes an extra piece of information to reveal
who the sender is. Therefore it is advised to mix transactions with standard chunk sizes, which means that large amount of funds might require many rounds of
mixing, creating bad user experience (to be fair, this is not unique to centralized mixers, without something like [Confidential Transactions](https://people.xiph.org/~greg/confidential_values.txt)
which hides the transaction amount, decentralized mixers suffer the same problem). Section **6.3 Mixing** of the execellent book
[Bitcoin and Blockchain Technologies](https://d28rh4a8wq0iu5.cloudfront.net/bitcointech/readings/princeton_bitcoin_book.pdf) discussed some other potential
implementation issues with centralized mixers at length, including a set of guidelines for them to provider better quality services for their users, such as multiple
rounds of mixing.

Nonetheless, centralized mixers such as [bestmixer.io](https://bestmixer.io/en) might still be useful for people with certain threat models and risk profiles. 
[Most users](https://medium.com/@nopara73/traditional-bitcoin-mixers-6a092e59d8c2) who decide to mix their coins still choose centralized mixing services.

#### CoinJoin

[CoinJoin](https://bitcointalk.org/index.php?topic=279249.0) was proposed by Bitcoin developer [Gregory Maxwell](https://github.com/gmaxwell) in 2013, which removes the risk
of theft by a third party.

To construct a CoinJoin transaction, a group of users need to somehow find each other, perhap through a centralized discovery service.
Users then start to exchange their inputs and outputs to each other. Once all the inputs and outputs are collected, any user could
use them to construct an unsigned version of a transaction and pass them around for everyone to sign. After everyone verified the correctness of the transaction and signed it off,
the transaction could be broadcasted to the network.

Like centralized mixing, it is still important to make sure that all outputs has the same demomination. One of CoinJoin's downsides is that it requires fair amount of user interactions, which not only hurts usability but
also make it susceptible for [sybil attacks](https://en.wikipedia.org/wiki/Sybil_attack). For example, attackers can join the group and try to learn the linkage between inputs
and outputs. Even if inputs and outputs are exchanged on top of the anonymous communication protocols such as [Tor](https://www.torproject.org),
attackers can still reduce the size of the anonymity set if there are "users" controlled by them inside the group. [DOS](https://en.wikipedia.org/wiki/DOS) attack is also possible if
attacker double spends any inputs in the CoinJoin transaction (which requires retry after removing the bad parties) or refuse to sign at the last stage (which could perhaps be addressed
by a [PoW like solution](https://en.bitcoin.it/wiki/CoinJoin#What_about_DOS_attacks.3F_Can.27t_someone_refuse_to_sign_even_if_the_transaction_is_valid.3F)).

A variation of CoinJoin called [Chaumian CoinJoin](https://github.com/nopara73/ZeroLink/#ii-chaumian-coinjoin) improves upon the original CoinJoin by leveraging
[blind signatures](https://en.wikipedia.org/wiki/Blind_signature) to ensure that even if there is a centralized service (like the [coordinator](https://www.reddit.com/r/Bitcoin/comments/afjf9u/wasabi_wallet_what_is_the_coordinator/)
in [Wasabi Wallet](https://wasabiwallet.io)), it is still not in a position to learn the linkage between inputs and outputs.

[CoinShuffle](https://bitcointalk.org/index.php?topic=567625.0) attempts to address CoinJoin's anomymity issue by running a clever [decentralized protocols](http://crypsys.mmci.uni-saarland.de/projects/CoinShuffle/coinshuffle.pdf)
among participants. Assuming that Alice, Bob and Charlie are going to perform a CoinJoin and their freshly generated keys pairs are PubA/PrivA, PubB/PrivB and PubC/PrivC respectively. Following
is how the CoinShuffle could be carried out.
* Alice is randomly selected to know PubA, PubB and PubC. Bob is randomly selected to know PubB and PubC. Charlie is randomly only knows PubB.
* Alice uses PubC to encrypt her output address and PubB to encrypt the encrypted message again. Alice sends the double encryted message to Bob.
* Bob recieves the double encrypted message from Alice, decrypt it using PrivB. Encrypt his own output address using PubC. Send both encrypted messages to Charlie.
* Charlie receives both encrypted messages, decrypts them using PrivC, revealing both Alice and Bob's output addresses. He then uses them to construct the CoinJoin transaction together with his
own output address

This onion structure similiar to [Tor](https://www.torproject.org) ensures that no parties involved knows the ownship
of the outputs. [Shufflepuff](https://github.com/DanielKrawisz/Shufflepuff) is an attempt to implement CoinShuffle in the [Mycelium](https://wallet.mycelium.com) wallet, but the project
doesn't seem to be actively maintained any more.

In general, CoinJoin isn't wildly used in the Bitcoin ecosystem yet. [JoinMarket](https://github.com/JoinMarket-Org/joinmarket-clientserver) tries to tackle that problem by bringing
economical incentives into the equation, but it hasn't seen much adoption either. Bitcoin developer [Jimmy Song](https://twitter.com/jimmysong?lang=en) recently recorded a video calling for
[easy to use CoinJoin](https://www.youtube.com/watch?v=-G3b3NPGWRE), perhaps a breakthrough on the usability side is the key.

#### TumbleBit

Compared to CoinJoin, where funds are mixed in a single transaction. [TumbleBit](http://cs-people.bu.edu/heilman/tumblebit/) creates a linked
[payment channels](https://en.bitcoin.it/wiki/Payment_channels) between payer and payee through a centralized payment hub. The payment channels
can be linked by leveraging [Hashed Timelock Contract](https://en.bitcoin.it/wiki/Hashed_Timelock_Contracts), which guarantees that the payment
hub is unable to steal funds.

A [blinded puzzle technique](https://hackernoon.com/understanding-tumblebit-part-3-not-even-the-tumbler-can-breach-your-privacy-how-8d49d89e3a0d) inspired
by [blind signatures](https://en.wikipedia.org/wiki/Blind_signature) is used to ensure that the payment hub can not establish the connection between payer and payee. 

TumbleBit is currently integrated into the [Breeze wallet](https://github.com/stratisproject/Breeze) from [Stratis](https://stratisplatform.com).

### Amount
reveal how much money u have
reveal hiwja

#### Rounds based mixer, 8.6 coins take 8 times to mix
#### Unequal Input Mixing 
#### Confidential transactions (+ range proof?)
#### Mimblewimble
#### Ring CT
#### Zero knowledge proof

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

privacy easily used.
bulletproof for mopnaro
sapling for zcash
