# HLSCore

A collection of Swift packages for working with [HLS](https://developer.apple.com/streaming/).

Most notably:
1. An HLS Parser
2. Swift structures to represent HLS constructs
3. An HLS serializer.

HLSCore is in experimental development. It does not implement the full HLS specification.
It is built in the service of private tools and the command-line tool,
[scrape](https://github.com/fcanas/scrape).

## Organization

HLSCore is five packages. The organization of the project will change as real tools are
built on HLSCore.

* *Types* — Defines the core elements of HLS as Swift structs and enums
* *Parsing* — An HLS playlist parser built on [parser combinators](https://github.com/fcanas/FFCParserCombinator)
* *Serialization* — Converts HLS playlists defined in Types into strings
* *Utilities* — Shared bits of code

## License

HLSCore is available under the [MIT license](https://github.com/fcanas/HLSCore/blob/master/LICENSE).
