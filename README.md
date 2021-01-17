# Lobstersbot

This is the source for the IRC bot that lives in [`#lobsters`](irc://chat.freenode.net/#lobsters). It is based on [Summer](https://github.com/radar/summer).

## Installation
 Install it yourself as:

    $ gem install lobstersbot

## Usage

Create a configuration directory following the [Summer configuration format](https://github.com/radar/summer#configuration). Then run the bot:
    
    $ lobstersbot ./path/to/config/directory

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lobsters/lobstersbot.
