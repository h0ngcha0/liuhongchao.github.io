---
layout: post
category: Bitcoin, Cryptocurrency, Layer 2, Lightning network
title: Lightning Network Channel Establishment
---


{% highlight org %}

|------------+
| funding tx |
|------------+
      |
      |        +-------------+
      \--------| commit tx B |
               +-------------+
                  |  |  |  |  
                  |  |  |  | A's main output
                  |  |  |  \------------------ to A
                  |  |  |
                  |  |  |
                  |  |  |                  ,-- to B (& delay)
                  |  |  | B's main output /
                  |  |  \----------------<
                  |  |                    \ 
                  |  |                     `-- to A (& revocation key)
                  |  |
                  |  |                                                ,-- to B (& delay)
                  |  |                        +-----------------+    /
                  |  |                     ,--| HTLC-timeout tx |---<
                  |  | HTLC offered by B  /   +-----------------+    \
                  |  \-------------------<     (after timeout)        `-- to A (& revocation key)
                  |                       \
                  |                        `-- to A (& payment preimage)
                  |                        \
                  |                         `- to A (& revocation key)
                  |                   
                  |                                                   ,-- to B (& delay)
                  |                           +-----------------+    /
                  |                        ,--| HTLC-success tx |---<
                  | HTLC received by B    /   +-----------------+    \
                  \----------------------<     (w/ payment preimage)  `-- to A (& revocation key)
                                          \
                                           `-- to A (after timeout)
                                           \
                                            `- to A (& revocation key)
{% endhighlight %}


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