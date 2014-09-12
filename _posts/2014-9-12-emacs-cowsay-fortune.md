---
layout: post
category: Emacs
title: Little fun with emacs start buffer
---

![fortune in emacs]({{ site.baseurl }}/images/emacs-cowsay-fortune.png)

Emacs is essential to my daily work flow in the past couple of years,
and there are so many things that I love about it. On top of the list
is the fact that customization is built to the core of the editor. The
extensions written for Emacs are really not in any way different than
most other part of the editor. In fact, Emacs itself can be considered
as the extension of a tiny little core.

How easy is it to enjoy a little wisdom from a naughty cow when you
open up your favorite editor?

{% highlight elisp %}
(defun cowsay-fortune-fun ()
  "customzied scratch buffer"
  (let ((my-buffer (get-buffer "*scratch*")))
    (with-current-buffer my-buffer
      (insert (shell-command-to-string "cowsay $(fortune)")))
    (switch-to-buffer my-buffer)))
{% endhighlight %}

That's it! Just remember to have
[cowsay](http://en.wikipedia.org/wiki/Cowsay) and
[fortune](http://en.wikipedia.org/wiki/Fortune_(Unix)) installed :stuck_out_tongue:



