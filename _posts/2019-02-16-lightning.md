---
layout: post
category: Bitcoin, Cryptocurrency, Layer 2, Lightning network
title: Payment Channels in Lightning Network
---

One of the fundamental aspects of the [lighting network](https://en.wikipedia.org/wiki/Lightning_Network) protocol is how payment channels are established
and utilized to transfer funds. Just like TCP connection, payment channel is virtual in the sense that it is achieved by carefully designed
[smart contracts](https://en.wikipedia.org/wiki/Smart_contract) which gives user the illusion that there exists a channel. In this post, the smart contracts
expressed in Bitcoin script in different types of transactions within the lightning payment channel are discussed in details, with graphs illustrating their
potential behaviors under different scenarios.


### Funding Transaction

Assuming that Alice and Bob want to establish a lightning channel between themselves,
a transaction with a 2-of-2 [multisig](https://en.bitcoin.it/wiki/Multisignature) output that
requires both of their signatures to unlock needs to be committed to the blockchain. This is
called a [funding transaction](https://github.com/lightningnetwork/lightning-rfc/blob/master/03-transactions.md#funding-transaction-output).

<img src="{{ site.baseurl }}/images/lightning/funding-transaction.png" alt="finding transaction"/>
<a target="_blank" rel="noopener noreferrer" class="image-label" href="{{ site.baseurl }}/images/lightning/funding-transaction.png">original image</a>

As illustrated above, inputs of the funding transaction are usually (but not neccessarily) contributed by Alice and/or Bob.
Output **0** and **1** represents the potential [changes](https://en.bitcoin.it/wiki/Change) going back to the addresses that Alice or Bob controls.
What's important is output **2** which contains a [P2WSH](https://github.com/libbitcoin/libbitcoin-system/wiki/P2WSH-Transactions) multisig script
that locks up the total fund for the lifetime of this payment channel between Alice and Bob.

One obvious risk is that if either party disappears, neither of them will be able to get their money back. This is one of the issues
that [commitment transaction](https://github.com/lightningnetwork/lightning-rfc/blob/master/03-transactions.md#commitment-transaction) is designed to address.
For now, what we need to know is that commitment transactions always spend the multisig output of the funding transaction. As long as Alice and Bob broadcast
the funding transaction together with the first pair of commitment transactions, they will abtain the ability to get their funds back after a timeout.

### Commitment Transaction

After funding transaction is confirmed onchain, Alice and Bob can start updating the balance between themselves offchain using
[commitment transactions](https://github.com/lightningnetwork/lightning-rfc/blob/master/03-transactions.md#commitment-transaction). Each commitment
transaction can be thought of as a legal contract between Alice and Bob dictating how the balance should look like in different
scenarios. Since the contracts are expressed in Bitcoin script, they could be enforced at any time if either party choose to unilaterally
broadcast it to the Bitcoin network. With that in mind, Alice and Bob can confidently conduct unlimited number of commitment transactions knowing
that no one can be cheated during the process. This essentially turns payment channel into a cache where most the intermidiate balance updates get
resolved offchain, with onchain transaction only needed in case of disputes or final settlement, making Bitcoin network much more scalable.

Major design goals of the commitment transaction are:

* Payment can be made in both ways.
* Participants are guaranteed to be refunded after a certain period of time if the counterparty disappears.
* Only the latest mutually agreed upon state is valid.
* Whether the participants are the originator or final recepient of the payment or if the payment is just being relayed by them
should be indistinguishable.

<img src="{{ site.baseurl }}/images/lightning/commitment-transaction-overview.png" alt="commitment transaction overview"/>
<a target="_blank" rel="noopener noreferrer" class="image-label" href="{{ site.baseurl }}/images/lightning/commitment-transaction-overview.png">original image</a>


The input of the commitment transaction always unlocks the 2-of-2 multisig output of the funding transaction which, as illustrated above, requires both Alice
and Bob's signatures.  It is important to realize that each commitment transaction is held by one party and the counterparty holds an asymmetric version which
is functionally similiar but with built-in mechanisms to punish the owner if they try to cheat. Both version can be submitted independently if needed, only one
of them will succeed since they spend the same output.

Commitment transaction could potentially have 4 outputs. Use Alice's commitment transaction as example, they are:

* **to_local** Represents Alice's current balance.
* **to_remote**  Represents Bob's current balance.
* **Offered HTCL** Represents payment that flows from Alice to Bob.
* **Received HTLC** Represents Payment that flows from Bob to Alice.

Note that these outputs do not neccessarily exist in all commitment transactions. For example, if there is no payment flowing from Alice to Bob, Alice's commitment transaction
will not contain an **Offered HTCL** output.

In the following sections, each type of outputs is discussed in greater details.

#### to_local

<img src="{{ site.baseurl }}/images/lightning/commitment-transaction-to-local.png" alt="commitment transaction to_local"/>
<a target="_blank" rel="noopener noreferrer" class="image-label" href="{{ site.baseurl }}/images/lightning/commitment-transaction-to-local.png">original image</a>

**to_local** output represents the current balance of the holder in the channel, in our case Alice, through a
[Revocable Sequence Maturity Contracts (RSMC)](https://en.wikiversity.org/wiki/Revocable_Sequence_Maturity_Contracts). The purpose of RSMC is to ensure that all
previous balances can be revoked when the agreement for a new balance is reached between Alice and Bob.

In Alice's commitment transaction, RSMC in the **to_local** output can be encoded in the following [scriptSig](https://bitcoin.org/en/glossary/signature-script):

{% highlight Erlang %}
OP_IF
    <revocation_pubkey_alice>
OP_ELSE
    `to_self_delay`
    OP_CSV
    OP_DROP
    <delayed_pubkey_alice>
OP_ENDIF
OP_CHECKSIG
{% endhighlight %}

If the commitment transaction is the latest one agreed between both parties, Alice will be able to spend this output after some delay with **delayed_signature_alice**. The delay is delibrately put in place to give Bob some time to exercise
the *breach remedy* clause if Alice happens to break the agreement by spending this output after it becomes outdated. In fact, all outputs that return funds to the holder of
the commitment transaction must be delayed for `to_self_delay` blocks.

When the commitment transaction was just created, only Alice knew **revocation_pubkey_alice**'s corresponding private key **revocation_secretkey_alice**.
Assuming that Alice and Bob decide to create a new commitment transaction, Alice needs to share her **revocation_secretkey_alice** with Bob so that if Alice publishes the old
commitment transaction to the Bitcoin network, Bob can use it to compute **revocation_signature_alice** and potentially claim the fund in **to_local** output ahead of Alice (because of the delay).

Bitcoin doesn't natively support the concept of transaction revocation, RSMC essentially offers such a functionality by making an older output undesirable to spend by both parties.

However, this requires Bob to be online often and constantly monitor the network, something that is not always possible, that is where [WatchTower](https://github.com/mit-dci/lit/tree/master/watchtower)
comes into the picture.

#### to_remote

<img src="{{ site.baseurl }}/images/lightning/commitment-transaction-to-remote.png" alt="commitment transaction to_remote"/>
<a target="_blank" rel="noopener noreferrer" class="image-label" href="{{ site.baseurl }}/images/lightning/commitment-transaction-to-remote.png">original image</a>

**to_remote** represents the current balance of holder's counterparty in the channel, in our case Bob. Since Bob is unable to broadcast Alice's version of commitment transaction, no "breach remedy"
clause is needed here. The output can be spent immediately by Bob if **signature_bob** is provided.

#### Offered HTLC

<img src="{{ site.baseurl }}/images/lightning/commitment-transaction-offered-htlc.png" alt="commitment transaction to_remote"/>
<a target="_blank" rel="noopener noreferrer" class="image-label" href="{{ site.baseurl }}/images/lightning/commitment-transaction-offered-htlc.png">original image</a>

**Offered HTLC** represents the payment flowing from the holder of the commitment transaction to his/her counterparty, in our case, from Alice to Bob. [HTLC](https://en.bitcoin.it/wiki/Hash_Time_Locked_Contracts)
stands for Hash Time Locked Contracts, which essentially says "I will pay you this amount if you show me the answer to this quiz within a certain period of time, otherwise the fund returns back to me". 
Like the **to_local** output, **Offered HTLC** also contains a *breach remedy* clause in case Alice violates the agreement by publishing an outdated version of the commitment transaction.

In Alice's commitment transaction, **Offered HTLC** can be expressed in the following scriptSig:

{% highlight Erlang %}
% To Bob with Alice’s revocation key
OP_DUP OP_HASH160 <RIPEMD160(SHA256(revocation_pubkey_alice))> OP_EQUAL
OP_IF
    OP_CHECKSIG
OP_ELSE
    <htlc_pubkey_bob> OP_SWAP OP_SIZE 32 OP_EQUAL
    OP_NOTIF
        % To Alice via HTLC-timeout transaction (timelocked).
        OP_DROP 2 OP_SWAP <htlc_pubkey_alice> 2 OP_CHECKMULTISIG
    OP_ELSE
        % To Bob with preimage.
        OP_HASH160 <RIPEMD160(payment_hash)> OP_EQUALVERIFY
        OP_CHECKSIG
    OP_ENDIF
OP_ENDIF
{% endhighlight %}

Bob can spend the output immediately by providing **hltc_signature_bob** and **payment_preimage** within a certain period of time. **payment_preimage** is the answer to the quiz (preimage of a hash) that Alice requires Bob to
come up with to be able to claim the fund. No *breach remedy* clause is needed here.

Alice can spend the output after a delay by providing **htlc_signature_bob** and **htlc_sigature_alice** via a seperate **HTLC timeout** transaction, which in turn locks up the fund in
a RSMC contract. **htlc_signature_bob** is shared by Bob to Alice during the construction of this commitment transaction. As we can recall, RSMC contract contains a *to_self_delay* value which
specifies the time limit within which the counterparty can exercise the breach remedy clause. The *nLockTime* for the **HTLC timeout** transaction is set to *cltv_expiry*, which represents
the delay after which the HTLC times out. The reason for needing a seperate **HTLC timeout** transaction is that it allows HTLC to timeout before breach remedy can be exercised. Otherwise,
the required minimum timeout on HTLCs is lengthened by the delay for breach remedy, causing longer timeouts for HTLCs traversing the network.

The locking script for Alice's **HTLC timeout** transaction can be encoded in the following scriptSig:

{% highlight Erlang %}
OP_IF
    % Penalty transaction
    <revocation_pubkey_alice>
OP_ELSE
    `to_self_delay`
    OP_CSV
    OP_DROP
    <delayed_pubkey_alice>
OP_ENDIF
OP_CHECKSIG
{% endhighlight %}

It can either be spent by Alice using **delayed_signature_alice** after the delay for breach remedy, or by Bob using **revocation_signature_alice** if Alice publishes the
outdated version of the transaction.

#### Received HTLC

<img src="{{ site.baseurl }}/images/lightning/commitment-transaction-received-htlc.png" alt="commitment transaction to_remote"/>
<a target="_blank" rel="noopener noreferrer" class="image-label" href="{{ site.baseurl }}/images/lightning/commitment-transaction-received-htlc.png">original image</a>

**Received HTLC** represents the payment flowing to the holder of the commitment transaction from his/her counterparty, in our case, from Bob to Alice.
Similiar to **Offered HTLC**, **Received HTLC** also contains a breach remedy clause in case the owner (Alice) violates the agreement by publishing an outdated version of the commitment
transaction.

In Alice’s commitment transaction, Offered HTLC can be expressed in the following scriptSig:

{% highlight Erlang %}
% To Bob with Alice’s revocation key
OP_DUP OP_HASH160 <RIPEMD160(SHA256(revocation_pubkey_alice))> OP_EQUAL
OP_IF
    OP_CHECKSIG
OP_ELSE
    <htlc_pubkey_bob> OP_SWAP OP_SIZE 32 OP_EQUAL
    OP_IF
        % To Alice via HTLC-success transaction.
        OP_HASH160 <RIPEMD160(payment_hash)> OP_EQUALVERIFY
        2 OP_SWAP <htlc_pubkey_alice> 2 OP_CHECKMULTISIG
    OP_ELSE
        % To Bob after timeout.
        OP_DROP <cltv_expiry> OP_CHECKLOCKTIMEVERIFY OP_DROP
        OP_CHECKSIG
    OP_ENDIF
OP_ENDIF
{% endhighlight %}

Bob can spend the output by providing **htlc_signature_bob** after *cltv_expiry* has passed, meaning that the fund returns to the sender when HTLC times out. If Alice figures out the
preimage of the hash and spends the output by providing **htlc_signature_bob**, **htlc_signature_alice** and **payment_preimage**, the fund will be locked up in a **HTLC Success** transaction,
which looks almost identical to the **HTLC timeout** transaction but with *nLockTime* set to 0 (since we do not need to represent the *cltv_expiry* here). The output of the **HTLC Success** transaction
is the same RSMC contract as in **HTLC timeout** transaction.

### Closing Transaction

After exchanging potentially many commitment transactions, if there is no dispute between Alice and Bob about their respective final balance, they can collabrately construct a closing transction to
spend the 2-of-2 multisig output of the funding transction and split the funds as per agreement. This will effectively close the channel.

<br/>

References:
- Rusty Russell's blog posts about lightning network [1](https://rusty.ozlabs.org/?p=450), [2](https://rusty.ozlabs.org/?p=462), [3](https://rusty.ozlabs.org/?p=467), [4](https://rusty.ozlabs.org/?p=477).
- [Reaching The Ground With Lightning (draft 0.2)](https://github.com/ElementsProject/lightning/blob/master/doc/deployable-lightning.pdf).
- [BOLT #3: Bitcoin Transaction and Script Formats](https://github.com/lightningnetwork/lightning-rfc/blob/master/03-transactions.md#commitment-transaction)