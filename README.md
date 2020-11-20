# MdToBbcode

**Convert Markdown text to Bbcode**

Provides an API and an executable to convert MArkdown text to BBCode format

## Getting Started

### Prerequisites

You just need to have Ruby installed.

### Installing

MdToBbcode installs as any Rubygem, either using `gem` command or Bundler.

```bash
gem install md_to_bbcode
```

Or using Bundler, add this in your `Gemfile` and issue `bundle install`.

```
gem 'md_to_bbcode'
```

Once the gem is installed you can require its main library in your Ruby code and use its API:

```ruby
require 'md_to_bbcode'

puts 'This is **a bold Markdown text**'.md_to_bbcode
# => This is [b]a bold Markdown text[/b]
```

The gem also comes with a nice executable that can convert Markdown files to BBCode.

```bash
md_to_bbcode --input original_markdown_file.md --output converted_to_bbcode_file.bbcode
```

## Running the tests

Executing tests is done by:

1. Cloning the repository from Github:
```bash
git clone https://github.com/Muriel-Salvan/md_to_bbcode.git
cd md_to_bbcode
```

2. Installing dependencies
```bash
bundle install
```

3. Running tests
```bash
bundle exec rspec
```

## Packaging

Like any Rubygem:
```bash
gem build md_to_bbcode.gemspec
```

## Contributing

Please fork the repository from Github and submit Pull Requests. Any contribution is more than welcome! :D

## Versioning

We use [SemVer](http://semver.org/) for versioning.

## Authors

* **Muriel Salvan** - *Initial work* - [Muriel-Salvan](https://github.com/Muriel-Salvan)

## License

This project is licensed under the BSD License - see the [LICENSE](LICENSE) file for details
