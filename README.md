
# Synlog
*A visual logger for Synapse V3*.

## [Documentation](https://belkworks.github.io/synlog/)

## Prerequisites

Ensure the following line is in your `.npmrc`:

```ini
@belkworks:registry=https://npm.pkg.github.com
```

Example available [here](https://github.com/Belkworks/synlog-sink/blob/master/.npmrc).

## Installation

With [`pnpm`](https://pnpm.io/):

```sh
pnpm add @belkworks/synlog
```

With npm:

```sh
npm install @belkworks/synlog
```

## Usage

```ts
import { Synlog } from "@belkworks/synlog";

Synlog.print("Hello world!");
```
