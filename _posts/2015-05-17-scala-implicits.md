---
layout: post
category: Software, scala
title: implicits and method injection in Scala
---

I remember the horror when I first came across *implicit* in scala, it
sounded like a recipe for incomprehensible code. After a while I
started to realize that there are a number of use cases where it could
be very useful. An important example is [method
injection](http://eed3si9n.com/learning-scalaz/method-injection.html)
as it is discussed in the [learning
scalaz](http://eed3si9n.com/learning-scalaz/index.html) tutorial.

Essentially, with the combination of *type class* (in scala's
case just *trait*s) and *implicit*, we can "create" new methods for
existing data types without touching its source code. In languages
like Haskell, this can be achieved by creating type class instance for
a given data type, but it has the limitation of *global uniqueness of
instances*, meaning that in a fully compiled program there can only
exist at most one instance of a type class for a given data type. With
the *implicit* approach, scala can have local type class instances,
therefore different instances of a type class for the same data
type. It can be pretty convenient to change behavior of a data type
by just importing different *implicit*s definitions from different
packages.
