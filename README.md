# OsdiOdata

Converts OData filter strings into SQL for use in OSDI.  Currently assumes Postgres dialect.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'osdi_odata'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install osdi_odata

## Usage

````
odata_filter="odified_date gt '2018-08-01' or ( gender ne 'Male' and gender ne 'They')"

OsdiOdata.parse(odata_filter)

"modified_date > '2018-08-01' OR ( gender <> 'Male' AND gender <> 'They' )"

````

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joshco/osdi_odata.
