# ci-do

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/2e3763239b2d44189953a648abdbdb10)](https://app.codacy.com/app/Codacy/ci-do?utm_source=github.com&utm_medium=referral&utm_content=codacy/ci-do&utm_campaign=Badge_Grade_Dashboard)
[![](https://images.microbadger.com/badges/version/codacy/ci-do.svg)](https://microbadger.com/images/codacy/ci-do "Get your own version badge on microbadger.com")

Docker image to be used in Continuous Integration environments such as CircleCI, with tools to interact with Digital Ocean

## Usage

#### CircleCI

Use this image directly on CircleCI for simple steps

```
version: 2
jobs:
  build:
    docker:
      - image: codacy:ci-do:1.0.0
    steps:
      - checkout
      - setup_credentials:
          command: doctl auth init -t $TOKEN &>/dev/null
```