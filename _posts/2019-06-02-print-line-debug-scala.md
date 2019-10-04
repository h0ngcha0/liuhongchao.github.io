---
layout: post
category: Programming
title: A Scala 'debug' Macro
---

If you are one of those guys who
[do not use a debugger](https://lemire.me/blog/2016/06/21/i-do-not-use-a-debugger/) and felt that the more
efficient way to navigate a complex codebase is still through "careful thought, coupled with judiciously placed
print statements", then here is a [nifty macro](https://github.com/liuhongchao/debug4s) that I wrote to make it
hopefully slightly easier in Scala.

Following is some of the features it provides:

<img src="{{ site.baseurl }}/images/debug4s.png" alt="debug4s"/>
<a target="_blank" rel="noopener noreferrer" class="image-label" href="{{ site.baseurl }}/images/debug4s.png">original image</a>

After I posted it on [r/Scala](https://www.reddit.com/r/scala/comments/bv3kbp/small_macro_to_make_print_line_debugging_easier/),
I got some really nice feedback from [Ólafur Páll Geirsson](https://gist.github.com/olafurpg), who implemented a
[similiar function](https://gist.github.com/olafurpg/bf61edc60dcff8744fd02234298b8c10) using [sourcecode](https://github.com/lihaoyi/sourcecode)
and [pprint](http://www.lihaoyi.com/PPrint/) in the response, which is pretty cool. The only difference is that it doesn't support multiple parameters, but
it can be worked around by using several `debug` statement.

If you find it useful, take a look at [README.md](https://github.com/liuhongchao/debug4s/blob/master/README.md) to find out more.