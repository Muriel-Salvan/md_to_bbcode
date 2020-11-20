# md_to_bbcode

**Convert Markdown text to Bbcode**

Provides a **Ruby API and a command-line executable** to convert Markdown text to BBCode format.

## Installation

As a prerequisite, you just need to have [Ruby](https://www.ruby-lang.org/en/) installed in your system.

md_to_bbcode installs as any Rubygem, either using `gem` command or Bundler.

```bash
gem install md_to_bbcode
```

Or using Bundler, add this in your `Gemfile` and issue `bundle install`.

```ruby
gem 'md_to_bbcode'
```

## Usage

Once the gem is installed you can require its main library in your Ruby code and use its API:

```ruby
require 'md_to_bbcode'

# Convert a String directly
puts 'This is **a bold Markdown text**'.md_to_bbcode
# => This is [b]a bold Markdown text[/b]
```

The gem also comes with a nice executable that can convert Markdown files to BBCode.

```bash
# Display help
md_to_bbcode --help

# Convert a Markdown file into a BBCode file
md_to_bbcode --input original_markdown_file.md --output converted_to_bbcode_file.bbcode
```

## Which Markdown/BBCode flavour is supported?

There are so many flavours of those 2 markup languages that it is impossible to cover them all, but the goal of this project is to add more and more.

The list of supported syntaxes can be seen directly from the [test cases](https://github.com/Muriel-Salvan/md_to_bbcode/blob/master/spec/api_spec.rb).

## Developers' corner

### Getting the source

Source can be cloned from Github directly, and dependencies are installed with Bundler:

```bash
git clone https://github.com/Muriel-Salvan/md_to_bbcode.git
cd md_to_bbcode
bundle install
```

### Running the tests

Tests are done in RSpec. So executing tests is done by:

```bash
bundle exec rspec
```

### Packaging

md_to_bbcode is packaged with Rubygem:

```bash
gem build md_to_bbcode.gemspec
```

### Versioning

We use [SemVer](http://semver.org/) for versioning.

### Contributing

Please fork the repository from Github and submit Pull Requests. Any contribution is more than welcome! :D

## Authors

* **Muriel Salvan** - *Initial work* - [Muriel-Salvan](https://github.com/Muriel-Salvan)

## License

This project is licensed under the BSD License - see the [LICENSE](LICENSE) file for details
