---
layout: post
category: Philosophy
title: Commitments
---

When we think about commitments, we think about couples making
commitment to their relationship, a group of talented and enthusiastic
people determined to [bringing power to the morden
consumers](https://minnatechnologies.com/about/), or a country pledged
to [land a man to the
moon](https://www.youtube.com/watch?v=QXqlziZV63k) and return him
safely on earth. It is an obligation of being dedicated to a cause, an
activity or an entity, a process of focusing on something with all
neccessary resources at the expense of opportunity cost. It is the
force [that transforms a promise into
reality](https://www.sparkpeople.com/mypage_public_journal_individual.asp?blog_id=2925515).

I always have this mental image when I think about commitment: a
bigger, fluffier and unstructured space being mapped to a smaller,
clearer and structured space. It is about less, not more. It is
about making specific, irrevocable choices instead of leaving the
options open. Even though commitment takes hard work and perseverance,
many studies seem to suggest that it is a major factor for
happiness. Actually, being happy itself is something that we can
commit to as well.

As programmers, we must be the subset of human beings that has
the most intimacy towards the concept of commitments since we do _git
commit_ basically everyday. When we commit code, knowledge from a much
larger and fluid space are transformed to a specific
format stored on disk. We even get an id for this, called a
[commit
id](https://stackoverflow.com/questions/29106996/what-is-a-git-commit-id). The
commit id is an [SHA-1](https://en.wikipedia.org/wiki/SHA-1) hash,
which is in fact a crypographic commitment to a bunch of things, such
as the content of the file, commit date, commit message, id of the
previous commit, etc. When the hash is being created, information from a much larger
space is mapped to a space with only 160 bits, which is still really,
really huge, but theoretically speaking there exists infinite number of
[preimages](https://www.quora.com/What-are-preimages-in-the-context-of-cryptographic-hash-functions)
for any hash values.

The trick of a "good" hash function is to make
sure that the likelihood of finding another preimage that can be
hashed to the same value is astronomically low, otherwise the
cryptographic commitment is broken. This property is
called [collision
resistence](https://en.wikipedia.org/wiki/Collision_resistance). If we are being
objective, isn't that the case for all types of commitments? Last time
I checked,
[50%](https://www.wf-lawyers.com/divorce-statistics-and-facts/) of the
marriages in the United States will end in divorce. As much as we want
to romanticize it, it doesn't change the fact that commitment is a game
of probabilities.

In cryptography, hash function can be thought of as a member in a bigger
family called [commitment
scheme](https://en.wikipedia.org/wiki/Commitment_scheme), which "allows
one to commit to a chosen value (or chosen statement) while keeping it
hidden to others, with the ability to reveal the committed value
later." Hash can be thought of as one way to commit to static information. As
it turns out, we can create commitment to dynamic program as well, for
example, using [polynomial
commitment](http://cacr.uwaterloo.ca/techreports/2010/cacr2010-10.pdf). This
allows verifier who has this commitment to check if a claimed
evaluation of original program is valid. Under the hood, it is the same
probabilities game. Even though theoretically there might be infinite
number of programs that could produce the same commitment, the
likelihood of you happen to convince the verifier with another program
is astronomically small. Polynomial commitment at the core of many Zero
knowledge proofs (ZKP) systems, which has the potential to really help
us improve our current privacy situation.

Hash is my favourite cryptographic primitives. From user's
perspective, it does one thing and does it very well, it is simple and
easy to use to the extent where people just take it for granted. I
have a similiar believe that ZKP will make a great impact in near
future as well. It is fair to say that crypographic commitment schemes
have made the world a better place and improved the collective
happiness of the human beings, just like many other commitments we
make in our lives.


