# HLSCore

A collection of Swift packages for working with [HLS](https://developer.apple.com/streaming/).

HLSCore is three packages. The organization of the project will change as real tools are
built on HLSCore.

* *Parsing* — An HLS playlist parser built on [parser combinators](https://github.com/fcanas/FFCParserCombinator)
* *Types* — Defines the core elements of HLS as Swift structs and enums
* *Serialization* — Converts HLS playlists defined in Types into strings
HLSCore is in experimental development. It does not implement the full HLS specification.
It is built in the service of private tools and the command-line tool,
[scrape](https://github.com/fcanas/scrape).

## License

HLSCore is available under the [MIT license](https://github.com/fcanas/HLSCore/blob/master/LICENSE).
