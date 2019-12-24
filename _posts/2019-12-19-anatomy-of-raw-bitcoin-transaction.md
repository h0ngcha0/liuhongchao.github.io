---
layout: post
category: Fintech, Blockchain, Philosophy, Privacy
title: Anatomy of Bitcoin Raw Transactions
---

Recently I added a feature in [nioctib.tech](https://nioctib.tech) to
display bitcoin transactions in their hexadecimal format, with internal
structure illustrated by different colors and tooltips describing what those
numbers actually represent. The hope is that this could offer a
direct visual impression about how serialized transactions look like
and can potentially be used as a debugging tool as well.

So how do raw bitcoin transactions look like? Nothing is
more authoritative than the code:

<img src="{{ site.baseurl }}/images/bitcoin-core-tx-format-comment.png" alt="colorized bitcoin transaction" style="width: 450px;"/><br/>
<span class="image-label">Extracted from Bitcoin Core's [primitive/transaction.h](https://github.com/bitcoin/bitcoin/blob/v0.13.1rc2/src/primitives/transaction.h#L275)</span>

In the rest of the post, let's dissect both a pre-segwit transaction and a [segwit](https://en.wikipedia.org/wiki/SegWit) transaction down to the bytes.

### Basic transaction serialization (pre-segwit)

Following is the hexadecimal format of a basic transaction displayed in a colorized and structured way, let's break it down one color at a time.

<img src="{{ site.baseurl }}/images/pre-segwit-bitcoin-transaction-colorized.png" alt="colorized bitcoin transaction" style="width: 90%;"/><br/>
<span class="image-label">View [this transaction](https://nioctib.tech/#/transaction/fca2c14810803155fd47cbbb998338ceefb8a14ea2d7cbc4a6e0089e225ab922) at nioctib.tech</span>

#### Version
<span style="background: green; color: white; font-size: 80%">01000000</span> is a 4 bytes data that represents the transaction data format version.
Current possible values are 1 and 2. Version 2 was introduced as part of [BIP 68](https://github.com/bitcoin/bips/blob/master/bip-0068.mediawiki),
which repurposes the meaning of [nSequence](https://en.bitcoinwiki.org/wiki/NSequence) to prevent mining of a transaction until a certain age of the spent output
in blocks or timespan. In this particular example the transaction data format version is 1.


#### Transaction inputs
The following byte <span style="background: darkorange; color: white; font-size: 80%">01</span> represents the
number of transaction inputs, which means that this particular transaction contains exactly one transaction input.

<span style="background: darkblue; color: white; font-size: 80%">047fe7104d14f2e0dd3aed130379b09ef934f36a2647daac99f4ef5e0a54ccc5</span> is the id of the transaction has one output
that was spent by this input. The index of that output is represented by the next 4 bytes <span style="background: darkcyan; color: white; font-size: 80%">01000000</span>,
or 1 in decimal, which suggests that it is the 2nd output of the transaction since index is [zero based](https://en.wikipedia.org/wiki/Zero-based_numbering).

The long purple colored string afterwards <span style="background: darkmagenta; color: white; font-size: 80%">8a4730440220...e287940eb2dd4f35c3ee2a3</span> encodes the unlocking
script defined in this transaction input. As we can see [here](https://nioctib.tech/#/transaction/fca2c14810803155fd47cbbb998338ceefb8a14ea2d7cbc4a6e0089e225ab922) it is supposed to unlock
a [P2PKH](https://en.bitcoinwiki.org/wiki/Pay-to-Pubkey_Hash) locking script, therefore these number represent a signture and a public key.

<span style="background: blue; color: white; font-size: 80%">feffffff</span> is the sequence number of the transaction input, for a comprehensive discussion about what it means and its evolution
over the time, please take a look at this excellent Bitcoin StackExchange [anwser](https://bitcoin.stackexchange.com/questions/87372/what-does-the-sequence-in-a-transaction-input-mean).

#### Transaction outputs
The following byte <span style="background: darkorange; color: white; font-size: 80%">02</span> represents the
number of transaction outputs. As the number suggests, there are two outputs in this particular transaction.

Each transaction output is represented by two fields. In the case of the first transaction output, <span style="background: green; color: white; font-size: 80%">00ca9a3b00000000</span> represents
the bitcoin value carried by this output, which is 10 btc in decimal. <span style="background: red; color: white; font-size: 80%">17a9147a1b6b1dbd9840fcf590e13a8a6e2ce6d55ecb8987</span> is a hex
representation of a standard [P2PKH](https://en.bitcoinwiki.org/wiki/Pay-to-Pubkey_Hash) locking script.

The structure of the second transaction output looks exactly the same as the first one.

#### Locktime

<span style="background: darkred; color: white; font-size: 80%">e3b50700</span> is the locktime of the transaction, which dictates the block number or timestamp until which the transaction is locked.
For a more in depth explanation please checkout this great [post](https://learnmeabitcoin.com/guide/locktime) on [learnmeabitcoin.com](learnmeabitcoin.com).

### Segwit transaction serialization

<img src="{{ site.baseurl }}/images/segwit-bitcoin-transaction-colorized.png" alt="colorized bitcoin transaction" style="width: 90%;"/><br/>
<span class="image-label">View [this transaction](https://nioctib.tech/#/transaction/f2f398dace996dab12e0cfb02fb0b59de0ef0398be393d90ebc8ab397550370b) at nioctib.tech</span>

For version, transaction inputs, transaction outputs and locktime, they have exactly the same structure as basic transaction serialization. Please use the previous section as a reference and
the tooltip feature for raw transactions at [nioctib.tech](https://nioctib.tech) if it is not clear.

Instead, let's discuss flag and witnesses that are unique to segwit transactions.

#### Flag
<span style="background: darkred; color: white; font-size: 80%">0001</span> is unique to segwit transactions. The first byte <span style="background: darkred; color: white; font-size: 80%">00</span>
is dummy data that looks to the pre-segwit node like empty input from an invalid transaction, which means that the old node will discard it if it is received. For post-segwit nodes, it signals
that this is potentially a segwit transaction.

The second byte <span style="background: darkred; color: white; font-size: 80%">01</span> looks to the pre-segwit node like a transaction with 1 output, but since empty input is not allowed, it's not
really important. For post-segwit nodes though, it confirms that this is a segwit transaction. It will then expect the following bytes to encode transaction inputs, transaction outputs as well as
a sequence of witnesses (one for each transaction input) and the locktime.

#### Witnesses
In segwit transactions, each input would have a sequence of witnesses to help unlock the corresponding output. In this particular transaction, we only have one sequence of witnesses since we only
have one input.

<span style="background: darkorange; color: white; font-size: 80%">04</span> represents the number of witnesses in the sequence.
<span style="background: yellow; color: black; font-size: 80%">00</span>, <span style="background: black; color: white; font-size: 80%">483045022...8aa901</span>,
<span style="background: yellow; color: black; font-size: 80%">483045022...d02d01</span> and <span style="background: black; color: white; font-size: 80%">4752210261...0452ae</span> encodes those
four witnesses respectively.

It is worth noting that this format is only acceptable for post-segwit nodes. However, when post-segwit nodes processed transaction in this format and relay it to pre-segwit nodes, it will strip away
the Flag and Witness part. Therefore for pre-segwit nodes, these transactions look like transactions that any one can spend because signatures are in witnesses which are stripped away. That is why
segwit is a softfork.

----

References:
- [BIT-141 Segregated Witness (Consensus layer)](https://github.com/bitcoin/bips/blob/master/bip-0141.mediawiki)
- [BIP-144 Segregated Witness (Peer Services)](https://github.com/bitcoin/bips/blob/master/bip-0144.mediawiki)
- [BIP-68 Relative lock-time using consensus-enforced sequence numbers](https://github.com/bitcoin/bips/blob/master/bip-0068.mediawiki)
- [How is SegWit a soft fork](https://bitcoin.stackexchange.com/questions/52152/how-is-segwit-a-soft-fork/52153#52153)
- [Segregated witness: the next steps](https://bitcoincore.org/en/2016/06/24/segwit-next-steps/)

----

Edit:

Reddit [discussion](https://www.reddit.com/r/Bitcoin/comments/ec513o/displaying_any_raw_transaction_data_in_structured/)
