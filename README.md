# Vibe Wars

[Vibe Wars](https://vibewars.com) is a web2 tool for a web3 world. Find out which NFTs in a given collection are the most visually desirable!

Everyone loves to talk about rarity, but what about visual appeal? In a set of thousands of NFTs, which ones do people actually like the look of the most?

## Setup

You'll need:

- ruby >3 (specific version is in `Gemfile`)
- postgreql (if using stock `config/database.yml`)

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

## Performance

Check out our Skylight dashboard to see where we need help on performance improvements.

[![View performance data on Skylight](https://badges.skylight.io/problem/WVIgG7lyv4Tx.svg)](https://oss.skylight.io/app/applications/WVIgG7lyv4Tx) [![View performance data on Skylight](https://badges.skylight.io/typical/WVIgG7lyv4Tx.svg)](https://oss.skylight.io/app/applications/WVIgG7lyv4Tx) [![View performance data on Skylight](https://badges.skylight.io/rpm/WVIgG7lyv4Tx.svg)](https://oss.skylight.io/app/applications/WVIgG7lyv4Tx)

## Contributing

It's still very early days for this so your mileage will vary here and lots of things will break.

But almost any contribution will be beneficial at this point. Check the [current Issues](https://github.com/Shpigford/vibewars/issues) to see where you can jump in!

If you've got an improvement, just send in a pull request!

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

If you've got feature ideas, simply [open a new issues](https://github.com/Shpigford/vibewars/issues/new)!

## License & Copyright

Released under the MIT license, see the [LICENSE](https://github.com/Shpigford/vibewars/blob/main/LICENSE) file. Copyright (c) Sabotage Media LLC.
