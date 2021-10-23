# Vibe Wars

Vibe Wars is a web2 tool for a web3 world. Find out which NFTs in a given collection are the most visually desirable!

Everyone loves to talk about rarity, but what about visual appeal? In a set of thousands of NFTs, which ones do people actually like the look of the most?

## Setup

You'll need:

* ruby >3 (specific version is in `Gemfile`)
* postgreql (if using stock `config/database.yml`)

```shell
cd vibewars
bundle install
rails db:setup
```

You can then run the rails web server:

```shell
rails server
```

And visit [https://localhost:3000](https://localhost:3000)

## Running tests

N/A?

```shell
rails test
```

## License

MIT?
