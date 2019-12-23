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

### Basic transaction serialization

Following is the hexadecimal format of a basic transaction (pre-segwit), let's break it down one color at a time.

<img src="{{ site.baseurl }}/images/pre-segwit-bitcoin-transaction-colorized.png" alt="colorized bitcoin transaction" style="width: 450px;"/><br/>
<span class="image-label">View [this transaction](https://nioctib.tech/#/transaction/fca2c14810803155fd47cbbb998338ceefb8a14ea2d7cbc4a6e0089e225ab922) at nioctib.tech</span>

#### Version
<span style="background: green; color: white; font-size: 80%">01000000</span> is a 4 bytes data that represents the transaction data format version.
Current possible values are 1 or 2. In this particular example, the value is version 1, which is the initial transaction version. Version 2 was introduced as part of
[BIP 68](https://github.com/bitcoin/bips/blob/master/bip-0068.mediawiki), which repurposes the meaning of nSequence to prevent mining of a transaction until a certain age of
the spent output in blocks or timespan.


#### Transaction inputs
<span style="background: darkorange; color: white; font-size: 80%">01</span> represents the
number of transaction inputs, which means that this particular transaction contains exactly one transaction input.

<span style="background: darkblue; color: white; font-size: 80%">047fe7104d14f2e0dd3aed130379b09ef934f36a2647daac99f4ef5e0a54ccc5</span> is the id of the transaction whose
output was spent by this input and the index of the output is <span style="background: darkcyan; color: white; font-size: 80%">01000000</span>, which suggests that it is the
2nd output since [zero based numbering](https://en.wikipedia.org/wiki/Zero-based_numbering) is used here.

The entire purple colored string afterwards <span style="background: darkmagenta; color: white; font-size: 80%">8a4730440220...e287940eb2dd4f35c3ee2a3</span> encodes the unlocking
script for this transaction input. As we can see [here](https://nioctib.tech/#/transaction/fca2c14810803155fd47cbbb998338ceefb8a14ea2d7cbc4a6e0089e225ab922) it is supposed to unlock
a [P2PKH](https://en.bitcoinwiki.org/wiki/Pay-to-Pubkey_Hash) locking script, therefore these number represent a signture and a public key.

<span style="background: blue; color: white; font-size: 80%">feffffff</span> is the sequence number of the transaction input, more details please check [here](https://en.bitcoinwiki.org/wiki/NSequence).

#### Transaction outputs
<span style="background: darkorange; color: white; font-size: 80%">02</span> represents the
number of transaction outputs, which means that this particular transaction contains two of them.

Each transaction output is represented by two fields. Use the first transaction output as example: <span style="background: green; color: white; font-size: 80%">00ca9a3b00000000</span> represent
the bitcoin value it contains, which is 10 btc after decoding. <span style="background: red; color: white; font-size: 80%">17a9147a1b6b1dbd9840fcf590e13a8a6e2ce6d55ecb8987</span> encodes a standard
[P2PKH](https://en.bitcoinwiki.org/wiki/Pay-to-Pubkey_Hash) locking script. The second transaction output looks pretty much the same.

#### Locktime

<span style="background: darkred; color: white; font-size: 80%">e3b50700</span> is the locktime of the transaction, which dictates the block number or timestamp until which the transaction is locked. 

### Segwit transaction serialization

<img src="{{ site.baseurl }}/images/segwit-bitcoin-transaction-colorized.png" alt="colorized bitcoin transaction" style="width: 450px;"/><br/>

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
