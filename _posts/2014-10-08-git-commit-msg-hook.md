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
commit messages is not guaranteed to work. As always, automation is
the way to go.

It turns out that it is pretty easy to write a git commit-msg hook to
prepend the story id automatically if it is already present in the
branch name. Assuming that the format of the branch name is:

{% highlight bash %}
FOO-NNN-your-description
{% endhighlight %}

where N represents an arbitrary digit. The following code snippet can be
set up as [git commit-msg
hook](http://git-scm.com/book/en/Customizing-Git-Git-Hooks) to
automatically prepend "FOO-NNN: " to your commit message if there
wasn't one yet.

{% highlight bash %}
#!/bin/bash

print_warning(){
cat <<EOF
------------------------------------------------------------
Warning:

Your branch name is FOO compliant, but your commit message
is not. The format of the commit message should be:
"FOO-NNN: your commit message"
where FOO-NNN should be the same as your branch name.

Automatically applying prefix....
------------------------------------------------------------
EOF
}

test "" != "$(grep '^[[:space:]]*FOO-[[:digit:]][[:digit:]]*:' "$1")" || {
    BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

    if [[ $BRANCH_NAME =~ ^FOO-[[:digit:]]+- ]]; then
        # Branch name is FOO compliant, then assume the commit message
        # should be compliant as well.
        print_warning
        PREFIX=$(echo $BRANCH_NAME | sed 's/\(^FOO-[[:digit:]]*\)-.*/\1/')
        sed -i "0,/^/s//$PREFIX: /" $1
    fi
}
{% endhighlight %}

Great! Now we just need to remember to always name our branch correctly
:) If you really wanna have a bit of assurance about that
, we can have a simple git extension to verify the format of the
branch name before it is created. Let's say we want our branch name to
be compliant to the aforementioned format, the extension would look
something like this:

{% highlight bash %}
#!/bin/bash

usage(){
cat <<EOF
This is a git plugin which helps to check and/or create a FOO compliant branch name.

usage:

git foo-branch your-branch-name

EOF
}

print_error(){
cat <<EOF
The format of the branch name should be FOO-NNN-your_branch_description
EOF
}

print_congrats(){
cat <<EOF
Your branch name is FOO compliant :)
EOF
}

if [ "$#" -ne 1 ]; then
    usage
    exit 1
fi

if [[ $1 =~ ^FOO-[[:digit:]]+- ]]; then
    print_congrats
    git checkout -b "$1"
else
    print_error
    exit 1
fi
{% endhighlight %}

For more info please take a look at the code on
[Github](https://github.com/liuhongchao/git-branch-name-checker).

