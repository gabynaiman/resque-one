# Resque::One

[![Gem Version](https://badge.fury.io/rb/resque-one.svg)](https://rubygems.org/gems/resque-one)
[![CI](https://github.com/gabynaiman/resque-one/actions/workflows/ci.yml/badge.svg)](https://github.com/gabynaiman/resque-one/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/gabynaiman/resque-one/badge.svg?branch=master)](https://coveralls.io/r/gabynaiman/resque-one?branch=master)
[![Code Climate](https://codeclimate.com/github/gabynaiman/resque-one.svg)](https://codeclimate.com/github/gabynaiman/resque-one)

Resque plugin to specify uniq jobs with the same payload per queue. Have support for resque-status.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resque-one'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install resque-one

## Usage

```ruby
class MyJob
  extend Resque::Plugins::One
end
```

or

```ruby
class MyJob
  def self.one?
    true
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gabynaiman/resque-one.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).