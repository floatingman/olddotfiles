# Modular `bashrc` by File Sort Order

This directory contains all the parts of the core Easy Bash Terminal Configuration as well as extras that can be disabled or removed entirely. This allows people pilfering to do so more easily (as in, just a `wget` or `curl` command). The cost on login startup is minimal to put these into their own files. Yet this is far less complicated than some of the other options out there.

It also makes it far easier to maintain because you can simple source the individual files and test their content rather than building the whole thing and potentially messing up your currently running shell.

## File Ordering

Simple file ordering such as that used in `/etc/rc.d` is used with the added convention of naming everything initially with three digits. Consider the following guide for numbering:

* **000-099** - reserved for testing mock ups and things that come *before* the main configuration framework.

* **100-199** - Reserved for main configuration stuff upon which other extensions depend.

* **200-299** - Extensions designed to be used by other extensions.

* **500-899** - Extensions.

* **800-899** - Reserved for main configuration stuff.

* **900-999** - Reserved for testing mock ups and things that always come *after* the main configuration framework.

## Even and Odd

When incrementing stick with even numbers so that odd numbers can be for inserting things between other things. That way numbering carries some inferred context about the time. It's certainly not mandatory, but helpful.

## Adding Your Own Extensions

To code an extension that works with this system just create a file with a `.bash` suffix and store it however you want. Then either place it directly into the `.bashrc.d` directory or symlink it into it.
