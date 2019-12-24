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

#### Version

#### Flag

#### Transaction Inputs

#### Transaction Outputs

#### Witnesses

#### Locktime


https://bitcoin.stackexchange.com/questions/49097/what-does-a-segregated-witness-transaction-look-like


I think the following two picture shows 


<- luke jr says it is fairly obvious.. to have flag as 00

References:
- [BIT-141 Segregated Witness (Consensus layer)](https://github.com/bitcoin/bips/blob/master/bip-0141.mediawiki)
- [BIP-144 Segregated Witness (Peer Services)](https://github.com/bitcoin/bips/blob/master/bip-0144.mediawiki)
- [BIP-68 Relative lock-time using consensus-enforced sequence numbers](https://github.com/bitcoin/bips/blob/master/bip-0068.mediawiki)

----

Edit:

Reddit [discussion](https://www.reddit.com/r/Bitcoin/comments/ec513o/displaying_any_raw_transaction_data_in_structured/)
