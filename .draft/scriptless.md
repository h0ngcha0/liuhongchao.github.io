scriptless script

purpose

techniques

ad hoc simulation of existing script?


maybe right a post about how the bitcoin version is converted to its scriptless version

can grin do 2 of 3 multisig?
- look for threshold signatures

perhaps the right way to look at this is that

if the structure of the verification is lost in the script, then the structure will be
encoded in the interaction of the participants.


in a sense, if we use bitcoin script u already encoded the interaction in the chain

using scriptless script, you "implicitly" also encoded the interaction in the chain


schonrr multisig is already by definition scriptless script


Adaptor signature

crypto system is code, a lot of code actually, we tend to treat it as blackbox. 
but in fact it is more like smart contracts, once it is out there, it is just assumed to work.

preimage is an auxcilary data?

because in adaptive signatures, some value T is attached to it.

in adaptive signatures, you actually will need to reveal the secret `ti` to be able to construct
a valid signature.


translate the correct "movement" of the auxcilary protocol to the valid signature.

semi honest system, add a piece of incentive to make it work.


in mimblewimble, the kernel signature in effectively a multi-signature.

adaptive signature is a more general version of preimage chanllange, but put the preimage
as part of the signature (<- this is a crap way of putting it.)

grin approach is not satisfactory for Andrew, since it requires having extra info onchain.


hash(c) is a commitment to c, but the construct of "P = P´ + H(P´ + c)G" is also a commitment
to c, which has nicer property. namely the commitment itself is a public key in a curve and the
private key "x = x´ + H(P´ + c)". then this can do a lot of cool things since most bitcoin
transactions are using pub/priv keys, this effectively hides the fact that you commit to 
something. 

Reference:
https://github.com/mimblewimble/grin/blob/master/doc/contracts.md


in 
https://minatjanster.slack.com/messages
one sentence might be wrong:
> Alice can validate that sr'*G = kr*G + x*G + rr*G. She can also check that Bob has money locked with x*G on the other chain.
should be hash(x)


write why schonrr is better and preserves the aggregation.

signature really is a equation, (s, bla) and all of them mulitply by G should satisfy an equation.

Shnorr signatures and Ecdsa signatures