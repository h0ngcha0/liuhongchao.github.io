---
layout: post
category: Emacs
title: Emacs is the 2D Command-line Interface
---

One of the most popular arguments against Emacs is that it is "a great
operating system, lacking only a decent editor". The fact that many
hardcore Emacs users promote the idea of "Living in Emacs" only make
this argument more compelling. At the first glance, the idea of using
a single program for "everything" does seem to contradict the [Unix
philosophy](https://en.wikipedia.org/wiki/Unix_philosophy), which
favors special purpose programs that compose really well instead of
monolithic systems that try to solve many complex problems at the same
time. In this article, I'd like to make the argument that Emacs
largely follows the Unix philosophy in its problem domain: _working
with text_, and can be seen as a two dimentional version of the
[command-line
interface](https://en.wikipedia.org/wiki/Command-line_interface)
(CLI).

> This is the Unix philosophy: Write programs that do one thing and do
> it well. Write programs to work together. Write programs to handle
> text streams, because that is a universal interface.
>
> McIlroy, head of the Bell Labs Computing Sciences Research Center

Many CLI tools stood the test of time. Programs like _find_, _grep_,
_awk_, etc have been indispensable for IT professionals for
decades. They are effective, sometimes more so than their GUI
counterparts, because command line interpreters such as
[Bash](https://en.wikipedia.org/wiki/Bourne_shell) provides an
environment where they can be composed together to accomplish tasks
that the original designer of the individual program have never
thought about. For example, through the composition of _kubectl_,
_grep_, _awk_ and _base64_, the following command displays the content
of the _tls.crt_ certificate in a Kubernetes secret called
_nioctib-tech-it-tls_:

<img src="{{ site.baseurl }}/images/compose-cli.png" alt="compose cli"/>

Two things have made significant contribution to the composibility and
extensibility of the CLI tools:

- Text streams as the univeral interface
- Command line interpreter as a programming environment

There are definitely disadvantages to have text streams as the
universal interface between programs due to its lack of structure. But
the timelessness of many of the tools following this pattern and the
prosperity of the ecosystem in Unix-like systems proved its
effectiveness as a design choice. Text can be read by both human and
programs. It can be manipulated, printed, stored, trasferred, version
controlled with the tools of your choice. For programs that do not
inheritantly require structured data, using text streams as interface
provides the most composibility.

However, for programs that do require structured data, such as
browsers, image viewers, music players, etc. Their text based versions
usually become the toys of the hobbyists with neglectable impact.

<img src="{{ site.baseurl }}/images/lynx-browser.png" alt="lynx browser"/>
<span class="image-label">Lynx: a text based browser</span>

Another important contributor to the thriving of the CLI tools is the
fact that they live in a programmable environment. In Bash, programs
can be written from scratch or glued together using Bash script. This
makes the CLI environment infinitely extensible. By enabling smaller
programs that "do one thing and do it well" work together, it becomes
an environment that boosts synergy, productivity and creativity.

The word "line" in the CLI (Command-line interface) environment
indicates its one dimentional nature. For programs that potentially
need to interact with text files (two-dimentional), Emacs provides an
environment with similiar characteristics that makes CLI enviornment
successful: A universal text interface and a programming environment
which enables infinite extensibility.



What Emacs tries to achieve is
essentially become a two dimentional CLI environment while keeping all
the 


one dimentional you can do it well



argument, this is like CLI

CLI is not suitable for everything, so does Emacs


Not do everything in Emacs, just like dont do everything in CLI.