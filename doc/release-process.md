Release Process
====================

* Update hardcoded [seeds](/contrib/seeds)

* * *

- Create `SHA256SUMS.asc` for the builds, and GPG-sign it:
```bash
sha256sum * > SHA256SUMS
gpg --digest-algo sha256 --clearsign SHA256SUMS # outputs SHA256SUMS.asc
rm SHA256SUMS
```
(the digest algorithm is forced to sha256 to avoid confusion of the `Hash:` header that GPG adds with the SHA256 used for the files)
Note: check that SHA256SUMS itself doesn't end up in SHA256SUMS, which is a spurious/nonsensical entry.

- Upload zips and installers, as well as `SHA256SUMS.asc` from last step, to the racecrypto.com server

- Update racecrypto.com

- Announce the release:

  - Update Bitcoin ANN Thread

- Add release notes for the new version to the directory `doc/release-notes` in git master

- Celebrate & party!
