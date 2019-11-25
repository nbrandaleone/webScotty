# webScotty

This is an updated repo, of an older Haskell project (https://github.com/nbrandaleone/haskell-webservice).
The original repo did not use multi-stage Docker builds,
nor did it use a statically compiled binary. It also used cabal directly, whereas today the [stack](https://docs.haskellstack.org/en/v1.0.2/build_command/) tool is preferred.

This repo demonstrates a basic Haskell web server.  It uses
the Scotty [library](http://hackage.haskell.org/package/scotty),
which is similar in spirit to Ruby's Sinatra.

I created several versions of the Docker image, trying to get a minimal image size. I was inspired by the following blogs:
- https://www.fpcomplete.com/blog/2015/05/haskell-web-server-in-5mb
- https://www.fpcomplete.com/blog/2016/10/static-compilation-with-stack
- https://www.fpcomplete.com/blog/2017/12/building-haskell-apps-with-docker

In the final Docker image (tag: 0.5), I also used an amazing binary compression tool: [UPX](https://upx.github.io).  UPX is easy to use, and does a fantastic job of reducing the binary size.

## Multi-Stage docker build sizes
| Base image | Final image | Additional Tooling | Final Size | Tag |
| --- | --- | --- | --- | --- |
| fpco/stack-build:lts-14.15 | ubuntu:18.04 | NA | 113 MB | 0.1 |
| haskell:8.6.5 | fpco/haskell-scratch:integer-gmp | NA | 22 MB | 0.3 |
| haskell:8.6.5 | scratch | NA | 16 MB | 0.6 |
| haskell:8.6.5 | fpco/haskell-scratch:integer-gmp | UPX | 7 MB | 0.4 |
| haskell:8.6.5 | scratch | UPX | 3.3 MB | 0.5 |

## How to create a statically compiled Haskell binary
Haskell is typically dynamically compiled.  However, it is not
difficult (in most cases) to create a statically compiled binary.
The advantage is primarily a smaller binary, and improved portability (although if we are using Docker containers, we do not have to worry about portability any more. Yea!)

In order to create a static binary, I had to alter the cabal file.
In the executable section, add "ld-options: -static".
In the `stack build` section, add "-fPIC" option.

# and add "--ghc-options=-fPIC" to any stack "build" commands
# executable webScotty-exe
#   main-is: Main.hs
#     ld-options: -static
