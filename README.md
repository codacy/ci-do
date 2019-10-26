# ci-do
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/a9231f0c49ff4be9b00f79930207d224)](https://www.codacy.com/app/Codacy/ci-do?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=codacy/ci-do&amp;utm_campaign=Badge_Grade)
[![](https://images.microbadger.com/badges/version/codacy/ci-do.svg)](https://microbadger.com/images/codacy/ci-do "Get your own version badge on microbadger.com")

Docker image to be used in Continuous Integration environments such as CircleCI, with tools to interact with Digital Ocean

## Usage

### CircleCI

Use this image directly on CircleCI for simple steps

```yaml
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
