# HLSCore

A collection of Swift packages for working with [HLS](https://developer.apple.com/streaming/).

Most notably:
1. An HLS Parser ->
2. Swift structures to represent HLS constructs ->
3. An HLS serializer.

## Introduction

HLSCore will break into several parts to serve different roles.

First, HLSCore provides a set of domain types for working with HLS streams. It
codifies concepts from the HLS spec as simple Swift types and relationships.

A parser for master media playlists is built on top of the core types. A utility
for downloading all resources from a stream is being built. It may also be a
good foundation for a stream validator. I hope to make the parser suitable for
use in a player as well.

Another component serializes the HLSCore structures into playlists.

HLSCore is in experimental development. It does not yet implement the full HLS
specification. It is being built in the service of private tools and the
command-line tool, Strip, included in this repository. Remaining work includes
documenting interfaces and cataloging of incomplete HLS specification components.

## Organization

HLSCore is currently five packages. The organization of the project will change
as real tools are built on HLSCore.

* *Types* — Defines the core elements of HLS as Swift structs and enums
* *Parsing* — An HLS playlist parser built on parser combinators
* *Serialization* — Converts HLS playlists defined in Types into strings
* *Strip* — A command line tool to download all resources associated with an HLS stream
* *Utilities* — Shared bits of code

## License

HLSCore is available under the [MIT license](https://github.com/fcanas/HLSCore/blob/master/LICENSE).
