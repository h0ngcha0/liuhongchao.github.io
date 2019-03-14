- in paper, why not requiring bob's signature? otherwise alice can just spend it using revocation secret key right?

OP_IF
    <revocation_pubkey_alice>
OP_ELSE
    `to_self_delay`
    OP_CSV
    OP_DROP
    <delayed_pubkey_alice>
OP_ENDIF
OP_CHECKSIG


- if alice knows bob's htlc_signature_bob in Recieved HTLC, why not just pretend to be Bob and spend it after HTLC is expired?



random notes

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
