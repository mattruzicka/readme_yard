# Readme Yard 🌿
[![Gem Version](https://badge.fury.io/rb/readme_yard.svg)](https://badge.fury.io/rb/readme_yard)
[![Maintainability](https://api.codeclimate.com/v1/badges/9fe0012930c3886dbe00/maintainability)](https://codeclimate.com/github/mattruzicka/readme_yard/maintainability)

Build a better README with [YARD](https://yardoc.org)
by generating it straight from the source.

This gem aims to minimize the effort needed to keep your
README, documentation, and source code synced, useful,
and correct.

Look at the [README_YARD.md](https://github.com/mattruzicka/readme_yard/blob/main/README_YARD.md)
template for this project to see how it works.
If you're reading the README, that means this text is here
because the custom `{@readme ReadmeYard}` markdown tag is in
README_YARD.md and `readme build` was run at the command line.

Here's the [full documentation](https://rubydoc.info/github/mattruzicka/readme_yard).


---

⚠️ **It's tempting to accidentally edit README.md instead of README_YARD.md and lose your changes** by running `readme build`.

I plan on implementing safeguards to prevent this kind of thing, but ultimately I want to support editing the README directly. One idea is to leverage git in order to merge README.md changes into the relevant source code and README_YARD.md sections. The README_YARD.md file basically acts as a translation layer between your source code and README, so it can theoretically be used to generate changes both ways. I also think it could be used to keep state, like edit history, for implementing safeguards and awesome features. [PRs are welcome](#contributing); Feel free to reach out 🙂.

---

## Table of Contents
- [Installation](#installation)
- [Getting Started](#getting-started)
- [Command Line Usage](#command-line-usage)
- [Tag Usage](#tag-usage)
- [Readme Tag](#readme-tag)
- [Example Tag](#example-tag)
- [Contributing](#contributing)

---

## Installation

Add [gem "readme_yard"](https://rubygems.org/gems/readme_yard) to your Gemfile and run `bundle install` or install it yourself with: `gem install readme_yard`

## Getting Started

Run `readme build` at the command line. This creates a README_YARD.md file if there isn’t one by copying your exisiting README.md file.

README_YARD.md is the template from which `readme build` generates the README. Readme Yard adds the ability to embed and reference your source code in your README via README_YARD.md.

See [Tag Usage](#tag-usage).

---

## Command Line Usage

`readme` - Prints command line usage.

`readme build` - Reads from README_YARD.md and writes to README.md.

`readme doc` - Same as `readme build` + generates yard docs.


---

## Tag Usage

Readme Yard uses YARD tags and custom markdown tags. YARD tags live inside Ruby source code. The markdown tags live inside README_YARD.md.

When the Readme Yard build process encounters a tag in README_YARD.md, it searches the Ruby source code for its YARD tag counterpart, formats the output, and embeds it in the README file.

### Examples

The next line is a code snippet if you’re looking at [README.md](https://github.com/mattruzicka/README/blob/main/README_YARD.md) and `{@readme ReadmeYard.hello_world}` if you’re looking at [README_YARD.md](https://github.com/mattruzicka/readme_yard/blob/main/README_YARD.md).

```ruby
#
# @example
#   ReadmeYard.hello_world #=> "Hello 🌎 🌍 🌏"
#
def self.hello_world
  "Hello 🌎 🌍 🌏"
end
```


The markdown tag tells Readme Yard to parse the `@readme` tag located above the `hello_world` class method located in [lib/readme_yard.rb](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb).

To use another "meta" example, `{@readme ReadmeYard}` is used at the top of this project's README_YARD.md file to generate the first few sentences of this README. `ReadmeYard` references the class located in [lib/readme_yard.rb](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb).

Last one, `{@readme ReadmeYard#command_line_usage}` is used to generate the "Command Line Usage" section above from the comments of the `command_line_usage` instance method located in [lib/readme_yard.rb](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb). This method is extra meta: it returns the result of formatting its own comments as markdown. In this way, the usage instructions in the comments, the README, and as printed at the command line will always be in sync.

---

## Readme Tag

**Markdown** syntax: `{@readme ObjectPath}`

**YARD** syntax: `@example <name>`

By default, only the text nested under a @readme tag
will be embedded in the final output. The default
embed behavior can be changed through the use of tag names.


### Embed comments


Example usage:

```ruby
# @readme comment
```


This example ["@readme comment" tag](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/comment_tag.rb) embeds the below code snippet via the `{@readme ReadmeYard::CommentTag.format_tag_markdown}` markdown tag.

```ruby
#
# This comment is in the README because `@readme comment`
# is below (in the source code).
#
```


### Embed source code


Example usage:

```ruby
# @readme source
```


This example ["@readme source" tag](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/source_tag.rb) embeds the below code snippet via the `{@readme ReadmeYard::SourceTag.format_tag_markdown}` markdown tag.

```ruby
def format_tag_markdown(yard_object, _tag)
  ExampleTag.format_ruby(yard_object.source)
end
```


### Embed comments and source code


Example usage:

```ruby
# @readme object
```


This example ["@readme object" tag](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/object_tag.rb) embeds the below code snippet via the `{@readme ReadmeYard::ObjectTag.format_tag_markdown}` markdown tag.

```ruby
#
# This method's comment and code is in the README because
# `@readme object` is below (in the source code).
#
def format_tag_markdown(yard_object, _tag)
  text = CommentTag.format_docstring_as_comment(yard_object)
  text << "\n#{yard_object.source}"
  ExampleTag.format_ruby(text)
end
```



---

## Example Tag

**Markdown** syntax: `{@example ObjectPath}`

**YARD** syntax: `@example`

```ruby
#
# @example
#   ReadmeYard.hello_world #=> "Hello 🌎 🌍 🌏"
#
def self.hello_world
  "Hello 🌎 🌍 🌏"
end
```


The below example code is generated from `{@example ReadmeYard.hello_world}` because, as you can see above, the "hello_world" class method has an `@example` tag.

```ruby
ReadmeYard.hello_world #=> "Hello 🌎 🌍 🌏"
```


---

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mattruzicka/yard-readme.

If you're interested in contributing, but don't know where to get started, feel free to message me on twitter at [@mattruzicka](https://twitter.com/mattruzicka). I have a lot of ideas!

Thanks for taking the time to think about me, the README.

🌿 🥏 🌱 ⚽
