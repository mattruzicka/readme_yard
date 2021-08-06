# Readme Yard 🌿
[![Gem Version](https://badge.fury.io/rb/readme_yard.svg)](https://badge.fury.io/rb/readme_yard)
[![Maintainability](https://api.codeclimate.com/v1/badges/9fe0012930c3886dbe00/maintainability)](https://codeclimate.com/github/mattruzicka/readme_yard/maintainability)

An experiment in building a better README with
[YARD](https://yardoc.org).
Take a look at [README_YARD.md](https://github.com/mattruzicka/readme_yard/blob/main/README_YARD.md)
to see the template from which the README for this project was generated.

If you're reading the README, that means this text is here
because `{@readme ReadmeYard}` is in
[README_YARD.md](https://github.com/mattruzicka/readme_yard/blob/main/README_YARD.md)
and someone ran `readme build` at the command line.

If you're looking at the [source code](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb) or
[documentation](https://rubydoc.info/github/mattruzicka/readme_yard),
_welcome_ to readme yard!

---

## Command Line Usage

`readme` - Prints command line usage.

`readme build` - Reads from README_YARD.md and writes to README.md.

`readme doc` - Same as `readme build` + generates yard docs.

---

## Getting Started

Add [gem "readme_yard"](https://rubygems.org/gems/readme_yard) to your application's Gemfile and run `bundle install` or install it yourself with `gem install readme_yard`.

Next run `readme build` at the command line. This creates a README_YARD.md file if there isn’t one by copying the README file if it exists. It then parses README_YARD.md and writes the result to README.md.

In addition to being able to use tags as documented in the next section, you can edit the README_YARD file just as you would edit any README. Then to see changes made to README_YARD reflected in the README, run `readme build`.

---

## Usage

The following tags can be used in README_YARD.md to generate YARD documentation inside your README.

### @readme

Usage: `{@readme ObjectPath}`

`{@readme ReadmeYard}` is used at the top of this project's README_YARD.md file to generate this README's title and description. `ReadmeYard` references the class located in [lib/readme_yard.rb](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb).

`{@readme ReadmeYard#command_line_usage}` is used to generate the "Command Line Usage" section above from the comments located above. `ReadmeYard#command_line_usage` references the instance method `command_line_usage` located in [lib/readme_yard.rb](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb).

`{@readme ReadmeYard.hello_world}` - This object only exists so that you can read this in the README. `ReadmeYard.hello_world` references
the class method located in [lib/readme_yard.rb](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb).

### @example

Usage: `{@example ObjectPath}`

The below example code is generated from placing `{@example ReadmeYard.hello_world}` in README_YARD.md.

```ruby
ReadmeYard.hello_world => "Hello 🌎 🌍 🌏"
```

---

## Inspiration

The desire to have the code, README, and documentation for [Evolvable](https://github.com/mattruzicka/evolvable) be useful, synced, and correct as I work on documenting the [1.1.0 Release](https://github.com/mattruzicka/evolvable/pull/8).

I want a README that summarizes and contextualizes the code and documentation, without duplicating them, so as to make keeping it up-to-date easier. Laziness!

---

## Ideas

- Embed whole doc string if @readme tag is found, but there’s no text.

- Embed whole method if @example tag is found, but no text.

- `readme tags` - Prints usage and a list of all tags

- `readme tags -v` - Prints docstrings of all tags

- `readme tags <tag>` - Prints list of matching tags

- `readme tags <tag>` - Prints list of matching tag docstrings

- Improve linking. At the moment, there's lots of room for error when adding links in the YARD documentation.

- Support @todo tags or any other native YARD tags that might be useful.

- Add ability to target a particular tag in a doc string from README_YARD.md. Maybe via a tag directive?

- Follow @see links to find tags

- Integrate something like https://github.com/lsegal/yard-examples/blob/master/doctest/doctest.rb to add red/green test status to code example. Maybe via some sort of tag directive?

- Be able to customize the name of the source and target files.

- Integrate with the YARD server so that changes to documentation or README_YARD.md automatically regenerate the README

- Be able to register regexes for matching tags and running given blocks. Use to create functionality for tagging GitHub source.

---

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mattruzicka/yard-readme.
