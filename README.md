# Fairy Chores

I'm playing a bit with AI for hidden-role games - trying to figure out what's effective or fun for an AI to do as hidden-role game behaviour.

To do that, I first need a hidden-role game, so I'm starting from the theme of unscrupulous fairies skulking about and assigning each other to chore duty when they'd rather be freely frolicking.

## Usage

The intention is that there's a game model that lives in the library directories with thin layers of UI in the exe directory. Right now there's a text interface in exe/fc_text_console.

The obvious way to run it is like this:

~~~
Noahs-MBP-2:fairy_chores noah$ bundle exec exe/fc_text_console
Game type?
  1. nothing_happens
  2. assigners_win_now
  3. assigners_win

>
~~~

Then you can choose a game type, a number of fairies and (eventually) the actions you want to take.

## Installation

Normally you'd just clone the GitHub repo. If you need to install for some reason...

Add this line to your application's Gemfile:

```ruby
gem 'fairy_chores'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fairy_chores

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/fairy_chores. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/fairy_chores/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FairyChores project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/fairy_chores/blob/master/CODE_OF_CONDUCT.md).
