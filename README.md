# Race Core staging tree 0.12.2
<p align="center">
<a href="https://travis-ci.org/racecrypto/race" alt="Build Status">
<img src="https://travis-ci.org/racecrypto/racecoin.svg?branch=master"/>
</a>
<a href="https://github.com/racecrypto/racecoin/releases" alt="GIT Releases">
<img src="https://img.shields.io/github/downloads/racecoin/race/total.svg"/>
</a>
<a href="https://discord.racecrypto.com" alt="Discord">
<img src="https://img.shields.io/discord/402827967111233546.svg"/>
  </a>
<a href="https://twitter.racecrypto.com" alt="Twitter">
<img src="https://img.shields.io/twitter/follow/race_crypto.svg?style=social&label=Follow"/>
</a>
</p>
<p align="center">
  <a href="https://www.racecrypto.com">https://www.racecrypto.com</a> | <a href="https://explorer.racecrypto.com">Block Explorer</a> | <a href="https://bitcointalk.org/index.php?topic=2848766.0">Announcement</a> | <a href="https://discord.gg/hqEwrjZ">Discord</a> | <a href="https://twitter.com/race_crypto">Twitter</a>
</p>

## About Race

RACE offers highly secured, anonymous transactions across the world. RACE supports Masternodes with a superb block reward. Features as Private Send and Instant Send make RACE a future-oriented currency on the market. RACE uses peer-to-peer technology to operate with no central authority: managing transactions and issuing money are carried out collectively by the network. Race Core is the name of the open source software which enables the use of this currency. Race Core is based on the newest [Dash](https://www.dash.org) codebase and is its own currency.

For more information, as well as an immediately useable, binary version of
the Race Core software, see https://www.racecrypto.com

## Race Specifications

| Specification | Value |
| ------ | ------ |
| PoW Algorithm | Lyra2REv2 |
| Block Time Average | 90 seconds |
| Block Reward | 8 RACE |
| Block Reward Distribution | 40% to Masternodes, 60% to Miners initially, ramping up to 65% Masternodes, 35% miners |
| Masternode Collateral | 1000 RACE |
| Estimated Supply | 32.7 Mio. |
| Difficulty Retargeting | Every block |
| Difficulty Algorithm | Dark Gravity Wave v3 | 

## License

Race Core is released under the terms of the MIT license. See [COPYING](COPYING) for more
information or see https://opensource.org/licenses/MIT.

## Development Process

The `master` branch is meant to be stable. Development is normally done in separate branches.
[Tags](https://github.com/racecrypto/race/tags) are created to indicate new official,
stable release versions of Race Core.

The contribution workflow is described in [CONTRIBUTING.md](CONTRIBUTING.md).

## Testing

Testing and code review is the bottleneck for development; we get more pull
requests than we can review and test on short notice. Please be patient and help out by testing
other people's pull requests, and remember this is a security-critical project where any mistake might cost people
lots of money.

### Automated Testing

Developers are strongly encouraged to write [unit tests](/doc/unit-tests.md) for new code, and to
submit new unit tests for old code. Unit tests can be compiled and run
(assuming they weren't disabled in configure) with: `make check`

There are also [regression and integration tests](/qa) of the RPC interface, written
in Python, that are run automatically on the build server.
These tests can be run (if the [test dependencies](/qa) are installed) with: `qa/pull-tester/rpc-tests.py`

The Travis CI system makes sure that every pull request is built for Windows
and Linux, OS X, and that unit and sanity tests are automatically run.

### Manual Quality Assurance (QA) Testing

Changes should be tested by somebody other than the developer who wrote the
code. This is especially important for large or high-risk changes. It is useful
to add a test plan to the pull request description if testing the changes is
not straightforward.
