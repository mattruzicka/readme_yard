# Readme Yard 🌿
[![Gem Version](https://badge.fury.io/rb/readme_yard.svg)](https://badge.fury.io/rb/readme_yard)

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
- [Standalone Tag Usage](#standalone-tag-usage)
- [Example Tag](#example-tag)
- [Contributing](#contributing)

---

## Installation

Add [gem "readme_yard"](https://rubygems.org/gems/readme_yard) to your Gemfile and run `bundle install` or install it yourself with: `gem install readme_yard`

**Note:** As of version 0.3.0, Readme Yard requires Ruby 3.0 or higher.

## Getting Started

Run `readme build` at the command line. This creates a README_YARD.md file if there isn't one by copying your existing README.md file.

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

### Tag Reference Table

| Tag Type | YARD Syntax (in source code) | Markdown Syntax (in README_YARD.md) | Purpose |
|----------|------------------------------|-------------------------------------|---------|
| Readme | `@readme` | `{@readme ObjectPath}` | General purpose tag to embed content from source code |
| Readme (comment) | `@readme comment` | `{@comment ObjectPath}` | Embeds only the comment from source code |
| Readme (code) | `@readme code` | `{@code ObjectPath}` | Embeds only code implementation |
| Readme (source) | `@readme source` | `{@source ObjectPath}` | Embeds both comments and code |
| Readme (value) | `@readme value` | `{@value ObjectPath}` | Embeds a Ruby value as a Ruby code block |
| Readme (string) | `@readme string` | `{@string ObjectPath}` | Embeds a Ruby string as normal text |
| Example | `@example` | `{@example ObjectPath}` | Embeds example code from YARD @example tags |

> **Note:** For markdown tags that can be used without corresponding YARD tags in source code, see [Standalone Tag Usage](#standalone-tag-usage).

### Examples

The next line is a code snippet if you're looking at [README.md](https://github.com/mattruzicka/README/blob/main/README_YARD.md) and `{@readme ReadmeYard.hello_world}` if you're looking at [README_YARD.md](https://github.com/mattruzicka/readme_yard/blob/main/README_YARD.md).

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


This example [@readme comment](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/comment_tag.rb) tag embeds the below code snippet via the `{@readme ReadmeYard::CommentTag.format_tag}` markdown tag.

```ruby
#
# This comment is in the README because `@readme comment`
# is below (in the source code).
#
```


### Embed Ruby code


Example usage:

```ruby
# @readme code
```


This example [@readme code](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/code_tag.rb) tag embeds the below code snippet via the `{@readme ReadmeYard::CodeTag.format_tag}` markdown tag.

```ruby
def format_tag(yard_object, _tag)
  ExampleTag.format_ruby(yard_object.source)
end
```


### Embed Ruby comments and code


Example usage:

```ruby
# @readme source
```


This example [@readme source](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/source_tag.rb) tag embeds the below code snippet via the `{@readme ReadmeYard::SourceTag.format_tag}` markdown tag.

```ruby
#
# The comment and code for ReadmeYard::SourceTag#format_tag
# is in the README because `@readme source` is below (in the source code).
#
def format_tag(yard_object, _tag)
  text = CommentTag.format_docstring_as_comment(yard_object)
  text << "\n#{yard_object.source}"
  ExampleTag.format_ruby(text)
end
```


### Embed a Ruby value as a Ruby code block


Example usage:

```ruby
# @readme value
```


This example [@readme value](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/value_tag.rb) tag embeds the below code snippet via the `{@value ReadmeYard::ValueTag::EXAMPLE}` markdown tag.

```ruby
{ key: "value" }.freeze
```

### Embed a Ruby string as normal text


Example usage:

Because a [@readme string](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/string_tag.rb) tag:

```ruby
# @readme string
```


Is located above this constant:

```ruby
XZAMPLE = <<~STRING
  I heard you like self-documenting Ruby, so I wrote
  self-documenting Ruby for your self-documenting Ruby.
STRING
```


We see can see its string value as simple text below:

I heard you like self-documenting Ruby, so I wrote
self-documenting Ruby for your self-documenting Ruby.

---

## Standalone Tag Usage

While using the `@readme` tag in your source code is recommended because it makes the README's dependency on source code explicit, sometimes it's useful to embed source code snippets directly without it. This is especially valuable when a source object can only contain one `@readme` tag, but you want to highlight multiple aspects of the object.

You can use any of these tags directly in README_YARD.md without requiring a corresponding `@readme` tag in the source code:

- `{@comment ObjectPath}` - Embeds comments only
- `{@code ObjectPath}` - Embeds code only
- `{@source ObjectPath}` - Embeds both comments and code
- `{@value ObjectPath}` - Embeds a Ruby value as a Ruby code block
- `{@string ObjectPath}` - Embeds a Ruby string as plain text

For example, in the StringTag section above, we used both:
- `{@code ReadmeYard::StringTag::XZAMPLE}` to show the constant definition
- `{@string ReadmeYard::StringTag::XZAMPLE}` to display the string value as text

The standalone tag usage provides more flexibility when documenting your code and doesn't require modifications to the source files.

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
