# Readme Yard 🌿
[![Gem Version](https://badge.fury.io/rb/readme_yard.svg)](https://badge.fury.io/rb/readme_yard)
[![Maintainability](https://api.codeclimate.com/v1/badges/9fe0012930c3886dbe00/maintainability)](https://codeclimate.com/github/mattruzicka/readme_yard/maintainability)

Build a better README with [YARD](https://yardoc.org).

This gem aims to minimize the effort needed to
keep your README and docs useful and correct
by generating them straight from the source.

To see how it works, check out the
[README_YARD.md](https://github.com/mattruzicka/readme_yard/blob/main/README_YARD.md)
template for this project.
If you're reading the README, that means this text is here
because `{@readme ReadmeYard}` is in README_YARD.md
and `readme build` was run at the command line.
Here's the [full documentation](https://rubydoc.info/github/mattruzicka/readme_yard).


---

## Table of Contents
- [Installation](#installation)
- [Getting Started](#getting-started)
- [Command Line Usage](#command-line-usage)
- [Tag Usage](#tag-usage)
- [Readme Tag](#readme-tag)
- [Readme YARD Tags](#readme-yard-tags)
- [Example Tag](#example-tag)
- [Contributing](#contributing)

---

## Installation

Add [gem "readme_yard"](https://rubygems.org/gems/readme_yard) to your application's Gemfile and run `bundle install` or install it yourself with: `gem install readme_yard`

## Getting Started

Run `readme build` at the command line. That will create a README_YARD.md file if there isn’t one by copying your exisiting README.md file.

README_YARD.md is the template from which `readme build` generates the README. It augments your markdown with tagging capabilities as described in the section on [Tag Usage](#tag-usage).

---

## Command Line Usage

`readme` - Prints command line usage.

`readme build` - Reads from README_YARD.md and writes to README.md.

`readme doc` - Same as `readme build` + generates yard docs.


---

## Tag Usage

Readme Yard uses **README tags** and **YARD tags** in order to find, format, and embed Ruby source code inside README.md.

**README tags** live inside README_YARD.md.

**YARD tags** live inside Ruby source code.

When the Readme Yard build process encounters a tag in README_YARD.md, it searches the Ruby source code for its YARD tag counterpart, formats the output, and embeds it in the README file.

### Examples

This project's [README_YARD.md](https://github.com/mattruzicka/readme_yard/blob/main/README_YARD.md) has `{@readme ReadmeYard.hello_world}` just below this paragraph, unless you're looking at the [README]((https://github.com/mattruzicka/readme_yard/blob/main/README.md)) where you should instead see a code example which was generated from running `readme build`.

```ruby
#
# @example
#   ReadmeYard.hello_world #=> "Hello 🌎 🌍 🌏"
#
```


The README tag tells Readme Yard to parse the `@readme` YARD tag located above the `hello_world` class method located in [lib/readme_yard.rb](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb).

To use another "meta" example, `{@readme ReadmeYard}` is used at the top of this project's README_YARD.md file to generate the first few sentences of this README. `ReadmeYard` references the class located in [lib/readme_yard.rb](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb).

Last one, `{@readme ReadmeYard#command_line_usage}` is used to generate the "Command Line Usage" section above from the comments located above. `ReadmeYard#command_line_usage` references the instance method `command_line_usage` located in [lib/readme_yard.rb](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb).

---

## Readme Tag

**README Tag** syntax: `{@readme ObjectPath}`

**YARD Tag** syntax: `@example <name>`

By default, only the text nested under the @readme tag
will be embedded in the final output.

Different embed options are provided via the following
name options: `comment`, `source`, and `object`.


The above two sentences were generated via `{@readme ReadmeYard::ReadmeTag}` in README_YARD.md and the @readme tag at the top of [ReadmeYard::ReadmeTag class](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/readme_tag.rb).

## Readme YARD Tags


### Comment Tag

```@readme comment``` - Embeds the comment.


[This example comment tag](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/comment_tag.rb) embeds the below code snippet because `{@readme ReadmeYard::CommentTag.format_tag_markdown}` is in README_YARD.md.

```ruby
#
# This comment is in the README because `@readme comment`
# is below (in the source code).
#
```


### Source Tag

```@readme source``` - Embeds the source.


[This example source tag](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/source_tag.rb) embeds the below code snippet because `{@readme ReadmeYard::SourceTag.format_tag_markdown}` is in README_YARD.md.

```ruby
def format_tag_markdown(yard_object, _tag)
  ExampleTag.format_ruby(yard_object.source)
end
```



### Object Tag

```@readme object``` - Embeds the comment and source.


[This example object tag](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/object_tag.rb) embeds the below code snippet because `{@readme ReadmeYard::ObjectTag.format_tag_markdown}` is in README_YARD.md.

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

**README Tag** syntax: `{@example ObjectPath}`

**YARD Tag** example: `@example`

```ruby
#
# @example
#   ReadmeYard.hello_world #=> "Hello 🌎 🌍 🌏"
#
```


Given that the above comment is for the `hello_world` class method, the below example code is generated from placing `{@example ReadmeYard.hello_world}` in README_YARD.md.

```ruby
ReadmeYard.hello_world #=> "Hello 🌎 🌍 🌏"
```


---

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mattruzicka/yard-readme.

Thanks for taking the time to think about me, the README.

🌿 🥏 🌱 ⚽
