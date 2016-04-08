# RSwift

RSwift allows to create and develop iOS, OSX, tvOS and watchOS projects using CLI.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rswift'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rswift

## Usage

To create iOS app run `rswift app MyAppName`.

Enter app directory `cd MyAppName`.

Install gems `bundle install`.

Install pods `pod install`.

Install node modules `npm install`.


You can specify OSX, tvOS and watchOS template, for example `rswift app --template=osx MyOSXApp`.

Available templates are:
* `ios` (default)
* `osx`
* `tvos`
* `watchos` (still under development)

## Development

Run tests with `rake spec`.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lukwol/rswift-ios.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

