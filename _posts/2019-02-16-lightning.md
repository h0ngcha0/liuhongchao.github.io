---
layout: post
category: Bitcoin, Cryptocurrency, Layer 2, Lightning network
title: Lightning Network Channel Establishment
---

### Funding Transaction

Assuming that Alice and Bob want to establish a lightning channel between themselves,
a transaction that contains a 2-of-2 [multisig](https://en.bitcoin.it/wiki/Multisignature) output that
requires both of their signatures to unlock needs to be committed to the blockchain. This is
called a [funding transaction](https://github.com/lightningnetwork/lightning-rfc/blob/master/03-transactions.md#funding-transaction-output).

<img src="{{ site.baseurl }}/images/lightning/funding-transaction.png" alt="finding transaction"/>
<a target="_blank" rel="noopener noreferrer" class="image-label" href="{{ site.baseurl }}/images/lightning/funding-transaction.png">original image</a>

As illustrated above, inputs of the funding transaction are normally (but not neccessarily) contributed by Alice and/or Bob.
Changes might go back to the addresses that Alice or Bob controls, such as output **0** and **1**. What's important
is output **2** which contains a [P2WSH](https://github.com/libbitcoin/libbitcoin-system/wiki/P2WSH-Transactions) multisig locking script
that locks up the total fund for the channel between Alice and Bob.

One obvious risk is that if either party disappears, the other party will not be able to get their share of the money back. This is one of the issues
that commitment transaction is set out to address.



[**how to do write this?? combine with channel messages**]

### Commitment Transaction

After funding transaction is confirmed onchain, Alice and Bob can update the balance between themselves offchain using
[commitment transactions](https://github.com/lightningnetwork/lightning-rfc/blob/master/03-transactions.md#commitment-transaction). Each commitment
transaction can be thought of as a legal contract between Alice and Bob which details how the balance should look like in different
scenarios. Since clauses in the contract are expressed in Bitcoin script, they could be enforced at any time if either party choose to unilaterally
broadcast it to the Bitcoin network. With that knowledge in mind, Alice and Bob can confidently conduct unlimited number of commitment transactions knowing
that no one can be cheated during the process. This essentially turns the channel a cache where all the intermidiate balance updates get resolved, which makes Bitcoin
network much more scalable since it only needs to step in for disputed cases or the final settlement.

Major design goals of the commitment transaction are:

* Payment can be made in both ways.
* Participants are guaranteed to be refunded after a certain period of time if the counterparty disappears.
* Only the latest mutually agreed upon state is valid.
* Whether the participants are the originator or final recepient of the payment or if the payment is just being relayed by them
should be indistinguishable.

[It is important to realize that each commitment transaction has a asyncmetric version. (**how to justify**)]

<img src="{{ site.baseurl }}/images/lightning/commitment-transaction-overview.png" alt="commitment transaction overview"/>
<a target="_blank" rel="noopener noreferrer" class="image-label" href="{{ site.baseurl }}/images/lightning/commitment-transaction-overview.png">original image</a>



The input of the commitment transaction always unlocks the 2-of-2 multisig output of the funding transaction which, as illustrated by the picture above, requires both Alice
and Bob's signature.  The commitment transaction could potentially have 4 outputs.
**to_local** which pays



```
To allow an opportunity for penalty transactions, in case of a revoked commitment transaction, all outputs that return funds to the owner of the commitment transaction (a.k.a. the "local node") must be delayed for to_self_delay blocks. This delay is done in a second-stage HTLC transaction (HTLC-success for HTLCs accepted by the local node, HTLC-timeout for HTLCs offered by the local node).

The reason for the separate transaction stage for HTLC outputs is so that HTLCs can timeout or be fulfilled even though they are within the to_self_delay delay. Otherwise, the required minimum timeout on HTLCs is lengthened by this delay, causing longer timeouts for HTLCs traversing the network.
```
there is no reason to mix the to self delay whose purpose is to allow penalty if cheating and htlc timeout delay, whose purpose is to set a upper limit time box for answering the secret.

#### to_local

<img src="{{ site.baseurl }}/images/lightning/commitment-transaction-to-local.png" alt="commitment transaction to_local"/>
<a target="_blank" rel="noopener noreferrer" class="image-label" href="{{ site.baseurl }}/images/lightning/commitment-transaction-to-local.png">original image</a>

#### to_remote

<img src="{{ site.baseurl }}/images/lightning/commitment-transaction-to-remote.png" alt="commitment transaction to_remote"/>
<a target="_blank" rel="noopener noreferrer" class="image-label" href="{{ site.baseurl }}/images/lightning/commitment-transaction-to-remote.png">original image</a>

#### offered HTLC

<img src="{{ site.baseurl }}/images/lightning/commitment-transaction-offered-htlc.png" alt="commitment transaction to_remote"/>
<a target="_blank" rel="noopener noreferrer" class="image-label" href="{{ site.baseurl }}/images/lightning/commitment-transaction-offered-htlc.png">original image</a>

#### received HTLC

<img src="{{ site.baseurl }}/images/lightning/commitment-transaction-received-htlc.png" alt="commitment transaction to_remote"/>
<a target="_blank" rel="noopener noreferrer" class="image-label" href="{{ site.baseurl }}/images/lightning/commitment-transaction-received-htlc.png">original image</a>

### Settlement Transaction


Let's say Alice, Bob and Chris



Anchor transaction of Alice and Bob output

{% highlight Erlang %}
OP_HASH <SECRET-A-HASH> OP_EQUAL
OP_IF
  <KEY-B'>
OP_ELSE
  <KEY-B>
OP_ENDIF
2 OP_SWAP
<KEY-A> 2 OP_CHECKMULTISIG
{% endhighlight %}

To unlock the script, it has to know `SECRET-A`, also it needs either `KEY-A` & `KEY-B` or
`KEY-A` & `KEY-B'`.


some constructs



## HTLC

Get the money if you answer the question Within a certain period of time, otherwise the money goes
back to me.


- multi-sig deposit
Solves the problem of sending each other valid transactions offchain without worrying about
its validity

yeah, people can still broadcast old transactions to the network, that is a problem.

- 


Unidirectional payment channel is simple, if the amount increases all the time.

the possibility of using a older but more profitable transaction introduces a whole lot of
complexity.

# what is replacement by fee?

## Breach Remedy Transaction

Assuming A sends fund to B
(if A knows the secret, A and only A can spend it right away. if not, the money will
be sent to B within a certain period of time)

what is the penalty system? how can one can all counterparty's funds if a previous state was
broadcasted?

the revocation process is a bit hard to understand, but feels like it is not that hard actually


Basically, each output be can unlocked in two ways, either by me in near future or by
the counterparty if they know a secret (preimage of a hash function or private key). The secret
needs to be revealed to update the new local state, effectively revoking the previous state.

This is still useful, find out the Scala code

```
OP_IF
  <revocation_key>
OP_ELSE
 `to_self_delay`
  OP_CSV
  OP_DROP
  <local_delayedkey>
OP_ENDIF
OP_CHECKSIG
```

in https://rusty.ozlabs.org/?p=462
the timeout branch, why does it need the signature of the counter party?


A deep insight is that the only way to invalidate a transaction is to double spend it. 
the combination of CSV and preimage can solve that


- insights:
The only way to invalidate a transaction is to double spend it
but a restriction can be put on an UTXO so that it can not be spent within a certain
period of time.


when the original design is proposed, there is no output level delay for spending,
so the only thing that can work is to use the transaction level delay, which is locktime.

sign a transaction, which spends to yourselve with a delay (using locktime), with throwable key.
updating transaction means that the throwable key needs to be revealed and if the old transaction
is ever broadcasted (cheating) then all funds could be stolen.

what wants to be achieved is this:

from the sender perspective

requires both to sign off for the following shape:
(receiver secret + sender signature)

this is essentially the goal

if ((receiver secret + sender signature) && within delayed time)
  sender has the choice to profit immediately
else
  // as constructed
  receiver profit
  
|----------------|-------------------------------|----------------------------|
|                | ability                       | incentives                 |
|----------------|-------------------------------|----------------------------|
| receiver       | profit withithin certain time | profit within certain time |
|----------------|-------------------------------|----------------------------|
| sender         | branching                     | profit immediately         |
| with secret    |                               |                            |
|----------------|-------------------------------|----------------------------|
| sender         | zero                          | do nothing                 |
| without secret |                               |                            |
|----------------|-------------------------------|----------------------------|

-- in the original proposal
This if else is expressed through locktime + throwaway key from the
receiver. if receiver reveal the secret within the delayed time, then there will essentially
be a branch.

pays the total fund that is supposed to go to the receiver into a join output owned by 
receiver secret + sender signature

then spend this to receiver with a deley

- in the improved version with CSV?
This is expressed 

## HTLC

if you can answer the quiz within certain period of time
  you profit
else
 refund

sequence of promises


if else is still expressed using a timelock transaction, whereas it could be expressed using just
one transaction output


purpose:
this is used for chaining transactions




a timelock transaction was a way to do CLTV or CSV before


binding everything together
"embedded a HTLC into the shit"

### original implementation

### updated implementation

## channel setup

The timeout function, usually requires signatures from both parties, 

why in https://rusty.ozlabs.org/?p=462
it says all transactions have to be published to the blockchain?

reference:
1. this is an awesome explaination for revocation trick
https://bitcoin.stackexchange.com/questions/48053/what-is-a-hash-pre-image-as-it-is-used-for-the-breach-remedy

2. rusty always awesome
https://rusty.ozlabs.org/?p=450
https://rusty.ozlabs.org/?p=462
https://rusty.ozlabs.org/?p=467
https://rusty.ozlabs.org/?p=477

follow: https://medium.com/@rusty_lightning

3. 


today's agenda,
basically figure out the flow of lightning channel establishment.

- couple of scenarios?
- what message was exchanged?
- down to the script level