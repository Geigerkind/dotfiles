# Guides

Here described some information that can help with configuring plugin.

## Aliases how-to

Aliases is a feature that most shells support only in interactive mode. Also most shells, when used to run single command and exit without any user-friendly interaction, doesn't use this mode. As you might guess, this is exactly case of that plugin. So there is two ways to make plugin work with aliases:

- Force shell to use interactive mode anyway.
- Configure shell to expand aliases and let use them in non-interactive mode.

Both ways leads to things that can be different in different shells. But most of popular ones has similar option to force interactive mode: is `-i` or `--interactive` option. And that can be enough.

Also plugin must have information about which aliases are available, for that it's has corresponding preference. Most of shells supports getting such list by one command. The problem is different output formats. To keep being universal, plugin takes just a list with line break separated names, but you have to deal with converting shell output to that list.

**Here goes some shell-specific tips:**

### Bash

To get aliases:
```sh
bash -i -c alias | sed -e 's/alias\s*//; s/=.*//'
```

### Fish

To get aliases and functions:
```sh
fish -c alias | sed -e 's/^alias\s//; s/\s.*//' && fish -c functions
```
Interactive mode is not required with default configuration.

---

*If you have something to add, for example, related to specific shell, you can always send a pull request or an issue.*