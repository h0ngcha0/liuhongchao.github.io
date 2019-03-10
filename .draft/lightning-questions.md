in paper, why not requiring bob's signature? otherwise alice can just spend it using revocation secret key right?

OP_IF
    <revocation_pubkey_alice>
OP_ELSE
    `to_self_delay`
    OP_CSV
    OP_DROP
    <delayed_pubkey_alice>
OP_ENDIF
OP_CHECKSIG