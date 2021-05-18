## Prisma precompile builds for Raspberry Pi (armv7)

This repository contains precompiled [prisma-engines](https://github.com/prisma/prisma-engines) for Raspberry Pi.

## How to use this repository

1. Download all 4 engines build from GitHub releases:
2. Extract these engines to a folder
3. Set the following environment variables in your shell or in the `.env` file:

```sh
PRISMA_QUERY_ENGINE_BINARY=/path/to/query-engine
PRISMA_MIGRATION_ENGINE_BINARY=/path/to/migration-engine
PRISMA_INTROSPECTION_ENGINE_BINARY=/path/to/introspection-engine
PRISMA_FMT_BINARY=/path/to/prisma-fmt
```

4. You are now ready to use Prisma on raspberry Pi.

## Additional notes

CI in this repository check for a new major Prisma version everyday and if there is a new release avaliable, it will automatically build the engines and make a new release.
