<!-- SPDX-FileCopyrightText: 2024 antlers <antlers@illucid.net> -->
<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
<h1>Kanata Config</h1>

Magic Strdy w/ Taipo

## Building

Requires Guile.

``` bash
git clone 'https://github.com/antler5/kanata-config'
cd kanata-config
make
```

## Authenticating

You may verify that each commit in this branch has been signed by an
authorized contributer via GNU Guix's
[authentication](https://guix.gnu.org/manual/en/html_node/Invoking-guix-git-authenticate.html)
mechanism.

``` bash
git remote add keyring 'https://github.com/antler5/keyring'
git fetch keyring keyring:keyring
guix git authenticate \
  '3af48dec67bdfa1c08f0e0b599fb3598f5d8d8ce' \
  'DACB 035F B9B0 EE9C 7E13  1AAA C310 15D9 6620 A955'
```

## License

Unless otherwise specified, this projects comprises materials under
three licenses:  
- Code sources and snippets are
[GPL-3.0-or-later](https://www.gnu.org/licenses/gpl-3.0.html).  
- The README and other texts are
[CC-BY-SA-4.0](https://creativecommons.org/licenses/by-sa/4.0/).  
- Trivial files may be explicitly released as
[CC0-1.0](https://creativecommons.org/publicdomain/zero/1.0/legalcode).
