# HLSCore

A collection of Swift packages for working with [HLS](https://developer.apple.com/streaming/).

## Introduction

HLSCore is a project that is intended to break into multiple parts to serve
different roles.

First, HLSCore is intended to provide a set of domain-specific
types for working with HLS streams. It basically codifies the HLS spec as Swift
structs and enums and lets you establish or manipulate those structures and
their relationships.

A parser for master media playlists is built on top of the core types. A utility
for downloading all resources from a stream is being built on top of the parser.
It may also be a good foundation for building a stream validator. I hope to make
the parser suitable for use in a player as well.

Another component serializes the HLSCore structures into playlists.

HLSCore is in experimental development. It does not yet implement the full HLS
specification. It is first being built in the service of some private tools, and
the command-line tool Strip, included in this repository. When those are
complete, the next planned steps are documentation of interfaces and cataloging
of remaining work to support the complete HLS specification.

## Organization

HLSCore is divided into five packages. The organization of the project is likely
to change as real tools are built on HLSCore.

* *Types* — Defines the core elements of HLS as Swift structs and enums
* *Parsing* — An HLS playlist parser built on parser combinators
* *Serialization* — Converts HLS playlists defined in Types into strings
* *Strip* — A command line tool to download all resources associated with an HLS stream
* *Utilities* — Shared bits of code

## License

HLSCore is available under the [MIT license](https://github.com/fcanas/HLSCore/blob/master/LICENSE).
