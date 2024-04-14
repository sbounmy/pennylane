# Pennylane Ruby Library

The Pennylane Ruby library provides convenient access to the Pennylane API from applications written in the Ruby language. It includes a pre-defined set of classes for API resources that initialize themselves dynamically from API responses which makes it compatible with a wide range of versions of the Pennylane API.
It only works with the [buys and sales API](https://pennylane.readme.io/reference/versioning).

It was inspired by the [Stripe Ruby library](https://github.com/stripe/stripe-ruby).


## Documentation
See the [Pennylane API](https://pennylane.readme.io/reference/versioning) docs.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add pennylane

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install pennylane

## Requirements
Ruby 2.3+.

## Usage

The library needs to be configured with your account's token api which is available in your Pennylane Settings. Set Pennylane.api_key to its value:

```ruby
require 'pennylane'
Pennylane.api_key = 'x0fd....'

# list customers
Pennylane::Customer.list

# filter and paginate customers
Pennylane::Customer.list(filter: [{field: 'name', operator: 'eq', value: 'Apple'}], page: 2) per_page

# Retrieve single customer
Pennylane::Customer.retrieve('38a1f19a-256d-4692-a8fe-0a16403f59ff')
```

## Test mode
Pennylane provide a [test environment](https://help.pennylane.com/fr/articles/18773-creer-un-environnement-de-test). You can use the library with your test token api by setting the Pennylane.api_key to its value.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test-unit` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sbounmy/pennylane. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/pennylane/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pennylane project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/pennylane/blob/main/CODE_OF_CONDUCT.md).