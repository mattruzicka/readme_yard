# Readme Yard 🌿
[![Gem Version](https://badge.fury.io/rb/readme_yard.svg)](https://badge.fury.io/rb/readme_yard)
[![Maintainability](https://api.codeclimate.com/v1/badges/9fe0012930c3886dbe00/maintainability)](https://codeclimate.com/github/mattruzicka/readme_yard/maintainability)

{@readme ReadmeYard}

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

{@readme ReadmeYard#command_line_usage}

---

## Tag Usage

Readme Yard uses **README tags** and **YARD tags**. **README tags** live inside README_YARD.md. **YARD tags** live inside Ruby source code.

When the Readme Yard build process encounters a tag in README_YARD.md, it searches the Ruby source code for its YARD tag counterpart, formats the output, and embeds it in the README file.

### Examples

This project's [README_YARD.md](https://github.com/mattruzicka/readme_yard/blob/main/README_YARD.md) has `{@readme ReadmeYard.hello_world}` just below this paragraph, unless you're looking at the [README]((https://github.com/mattruzicka/readme_yard/blob/main/README.md)) where you should instead see a code example which was generated from running `readme build`.

{@readme ReadmeYard.hello_world}

The README tag tells Readme Yard to parse the `@readme` YARD tag located above the `hello_world` class method located in [lib/readme_yard.rb](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb).

To use another "meta" example, `{@readme ReadmeYard}` is used at the top of this project's README_YARD.md file to generate the first few sentences of this README. `ReadmeYard` references the class located in [lib/readme_yard.rb](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb).

Last one, `{@readme ReadmeYard#command_line_usage}` is used to generate the "Command Line Usage" section above from the comments located above. `ReadmeYard#command_line_usage` references the instance method `command_line_usage` located in [lib/readme_yard.rb](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb).

---

## Readme Tag

**README Tag** syntax: `{@readme ObjectPath}`

**YARD Tag** syntax: `@example <name>`

{@readme ReadmeYard::ReadmeTag}

The above two sentences were generated via `{@readme ReadmeYard::ReadmeTag}` in README_YARD.md and the @readme tag at the top of [ReadmeYard::ReadmeTag class](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/readme_tag.rb).

## Readme YARD Tags


### Comment Tag

{@readme ReadmeYard::CommentTag}

[This example comment tag](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/comment_tag.rb) embeds the below code snippet because `{@readme ReadmeYard::CommentTag.format_tag_markdown}` is in README_YARD.md.

{@readme ReadmeYard::CommentTag.format_tag_markdown}

### Source Tag

{@readme ReadmeYard::SourceTag}

[This example source tag](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/source_tag.rb) embeds the below code snippet because `{@readme ReadmeYard::SourceTag.format_tag_markdown}` is in README_YARD.md.

{@readme ReadmeYard::SourceTag.format_tag_markdown}


### Object Tag

{@readme ReadmeYard::ObjectTag}

[This example object tag](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/object_tag.rb) embeds the below code snippet because `{@readme ReadmeYard::ObjectTag.format_tag_markdown}` is in README_YARD.md.

{@readme ReadmeYard::ObjectTag.format_tag_markdown}


---

## Example Tag

**README Tag** syntax: `{@example ObjectPath}`

**YARD Tag** example: `@example`

{@readme ReadmeYard.hello_world}

Given that the above comment is for the `hello_world` class method, the below example code is generated from placing `{@example ReadmeYard.hello_world}` in README_YARD.md.

{@example ReadmeYard.hello_world}

---

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mattruzicka/yard-readme.

Thanks for taking the time to think about me, the README.

🌿 🥏 🌱 ⚽
