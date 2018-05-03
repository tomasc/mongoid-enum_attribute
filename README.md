# Mongoid::EnumAttribute

[![Build Status](https://travis-ci.org/tomasc/mongoid-enum_attribute.svg)](https://travis-ci.org/tomasc/mongoid-enum_attribute) [![Gem Version](https://badge.fury.io/rb/mongoid-enum_attribute.svg)](http://badge.fury.io/rb/mongoid-enum_attribute) [![Coverage Status](https://img.shields.io/coveralls/tomasc/mongoid-enum_attribute.svg)](https://coveralls.io/r/tomasc/mongoid-enum_attribute)

Updated and tweaked version of the no-longer-maintained [mongoid_enum](https://github.com/thetron/mongoid-enum).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mongoid-enum_attribute'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid-enum_attribute

## Usage

```ruby
class Payment
  include Mongoid::Document
  include Mongoid::Enum

  enum :status, [:pending, :approved, :declined]
end
```

Gives you getters,

```ruby
payment.status
# => :pending
```

setters,

```ruby
payment.approved!
# => :approved
```

conditionals,

```ruby
payment.pending?
# => :false
```

and scopes

```ruby
Payment.approved
# => Mongoid::Criteria for payments where status is :approved
```

## Prefix / Suffix

You can use the `:prefix` and `:suffix` options, to prefix or suffix the methods
of the enum. If the passed value is `true`, the methods are prefixed/suffixed
with the name of the enum. It is also possible to supply a custom value:

```ruby
enum :status, [:pending, :approved, :declined], prefix: true
enum :payments_status, [:pending, :approved, :declined], prefix: :payments

enum :status, [:pending, :approved, :declined], suffix: true
enum :payments_status, [:pending, :approved, :declined], suffix: :payments
```

This will result in the following methods:

```ruby
payment.status_declined! # prefix: true
payment.payments_declined! # prefix: :payments

payment.declined_status! # suffix: true
payment.declined_payments! # suffix: :payments
```

If you want to change the behaviour app-wide you can use the configuration:

```ruby
Mongoid::EnumAttribute.configure do |config|
  config.field_name_prefix = '_' # prefix of the field used to store the values in database
  config.prefix = nil # prefix of the ! & ? method
  config.suffix = nil # suffix of the ! & ? method
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mongoid-enum_attribute.
