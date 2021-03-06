# DataSink::Client

[![Build Status](https://travis-ci.com/deliveroo/data-sink-client.svg?token=ssKSGhx3XHB81qd6SvHz&branch=master)](https://travis-ci.com/deliveroo/data-sink-client)

A small client library for [data-sink](https://github.com/deliveroo/data-sink).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'data-sink-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install data-sink-client

## Usage

```
client = DataSink::Client.new(user: 'user', pass: 'pass', ...)
client.post(stream_id, body)

# or, if body already compressed:

client.post_gzipped(stream_id, body)
```

Options (with defaults):

```
url: ''
endpoint: '/archives'
retry_max: 2
retry_interval: 0.1
retry_backoff_factor: 2
adapter: :excon
read_timeout: 5
open_timeout: 5
add_newlines: true
```

or pass a Faraday client yourself with `client:`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/deliveroo/data-sink-client.

