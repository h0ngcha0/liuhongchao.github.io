---
layout: post
category: Software
title: Prepending story id in git commit messages
---

It is a good idea to prefix the git commit message with story id for
better traceability. For the same reason, it is also nice to prefix
the branch name with story id as well, even though git branch is more
short lived than commit messages.

However, forcing developers manually prepending the story id to
commit messages every time they make a commit is not guaranteed to
work. Automating it would take one more thing out of their minds so
that they can focus on the problems they care.

It turns out that it is pretty easy to write a git commit-msg hook to
prepend the story id automatically if it is already present in the
branch name. Assuming that the format of the branch name is:

{% highlight bash %}
SEAL-NNN-your-description
{% endhighlight %}

where N represents an arbitrary digit. The following code snippet can be
set up as [git commit-msg
hook](http://git-scm.com/book/en/Customizing-Git-Git-Hooks) to
automatically prepend "SEAL-NNN: " to your commit message if there
wasn't one yet.

{% highlight bash linenos=table %}
#!/bin/bash

print_warning(){
cat <<EOF
------------------------------------------------------------
Warning:

Your branch name is SEAL compliant, but your commit message
is not. The format of the commit message should be:
"SEAL-NNN: your commit message"
where SEAL-NNN should be the same as your branch name.

Automatically applying prefix....
------------------------------------------------------------
EOF
}

test "" != "$(grep '^[[:space:]]*SEAL-[[:digit:]][[:digit:]]*:' "$1")" || {
    BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

    if [[ $BRANCH_NAME =~ ^SEAL-[[:digit:]]+- ]]; then
        # Branch name is SEAL compliant, then assume the commit message
        # should be compliant as well.
        print_warning
        PREFIX=$(echo $BRANCH_NAME | sed 's/\(^SEAL-[[:digit:]]*\)-.*/\1/')
        sed -i "0,/^/s//$PREFIX: /" $1
    fi
}
{% endhighlight %}

Now we just need to remember to always name our branch correctly
:stuck_out_tongue: If you really wanna have a bit of assurance about that
, we can have a simple git extension to verify the format of the
branch name before it is created. Let's say we want our branch name to
be compliant to the aforementioned format, the extension would look
something like this:

{% highlight bash linenos=table %}
#!/bin/bash

usage(){
cat <<EOF
This is a git plugin which helps to check and/or create a SEAL compliant branch name.

usage:

git seal-branch your-branch-name

EOF
}

print_error(){
cat <<EOF
The format of the branch name should be SEAL-NNN-your_branch_description
EOF
}

print_congrats(){
cat <<EOF
Your branch name is SEAL compliant :)
EOF
}

if [ "$#" -ne 1 ]; then
    usage
    exit 1
fi

if [[ $1 =~ ^SEAL-[[:digit:]]+- ]]; then
    print_congrats
    git checkout -b "$1"
else
    print_error
    exit 1
fi
{% endhighlight %}

For more info take a look at the code on
[Github](https://github.com/liuhongchao/git-branch-name-checker).

