# Readme Yard 🌿
[![Gem Version](https://badge.fury.io/rb/readme_yard.svg)](https://badge.fury.io/rb/readme_yard)

{@readme ReadmeYard}

---

⚠️ **Generated file warning** – Edit README_YARD.md, not README.md. Changes to README.md will be lost when running `readme build`.

### Future Work
- Implement safeguards to prevent accidental edits to README.md
- Support bidirectional editing through git integration

[PRs are welcome](#contributing) for these improvements.

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

{@readme ReadmeYard#command_line_usage}

---

## Tag Usage

Readme Yard uses YARD tags and custom markdown tags. YARD tags live inside Ruby source code. The markdown tags live inside README_YARD.md.

When the Readme Yard build process encounters a tag in README_YARD.md, it searches the Ruby source code for its YARD tag counterpart, formats the output, and embeds it in the README file.

### Tag Reference Table

| Tag Type | YARD Syntax (in source code) | Markdown Syntax (in README_YARD.md) | Standalone Tag* | Purpose |
|----------|------------------------------|-------------------------------------|----------------|---------|
| Readme | `@readme` | `{@readme ObjectPath}` | N/A | General purpose tag to embed content from source code |
| Readme (comment) | `@readme comment` | `{@readme ObjectPath}` | `{@comment ObjectPath}` | Embeds only the comment from source code |
| Readme (code) | `@readme code` | `{@readme ObjectPath}` | `{@code ObjectPath}` | Embeds only code implementation |
| Readme (source) | `@readme source` | `{@readme ObjectPath}` | `{@source ObjectPath}` | Embeds both comments and code |
| Readme (value) | `@readme value` | `{@readme ObjectPath}` | `{@value ObjectPath}` | Embeds a Ruby value as a Ruby code block |
| Readme (string) | `@readme string` | `{@readme ObjectPath}` | `{@string ObjectPath}` | Embeds a Ruby string as normal text |
| Example | `@example` | `{@example ObjectPath}` | N/A | Embeds example code from YARD @example tags |

> *Standalone tags allow embedding content without requiring corresponding YARD tags in source code. See [Standalone Tag Usage](#standalone-tag-usage) for details.

### Examples

The next line is a code snippet if you're looking at the [README](https://github.com/mattruzicka/readme_yard/blob/main/README.md) and `{@readme ReadmeYard::ExampleTag.hello_world}` if you're looking at [README_YARD.md](https://github.com/mattruzicka/readme_yard/blob/main/README_YARD.md).

{@readme ReadmeYard::ExampleTag.hello_world}

The markdown tag tells Readme Yard to parse the `@readme` tag located above the `hello_world` class method located in [lib/readme_yard/example_tag.rb](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/example_tag.rb).

To use another "meta" example, `{@readme ReadmeYard}` is used at the top of this project's README_YARD.md file to generate the first few sentences of this README. `ReadmeYard` references the class located in [lib/readme_yard.rb](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb).

Last one, `{@readme ReadmeYard#command_line_usage}` is used to generate the "Command Line Usage" section above from the comments of the `command_line_usage` instance method located in [lib/readme_yard.rb](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb). This method is extra meta: it returns the result of formatting its own comments as markdown. In this way, the usage instructions in the comments, the README, and as printed at the command line will always be in sync.

---

## Readme Tag

**Markdown** syntax: `{@readme ObjectPath}`

**YARD** syntax: `@example <name>`

{@readme ReadmeYard::ReadmeTag}

### {@readme ReadmeYard::CommentTag}

**Usage:**

{@example ReadmeYard::CommentTag}

This example [@readme comment](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/comment_tag.rb) tag embeds the below code snippet via the `{@readme ReadmeYard::CommentTag.format_tag}` markdown tag.

{@readme ReadmeYard::CommentTag.format_tag}

### {@readme ReadmeYard::CodeTag}

**Usage:**

{@example ReadmeYard::CodeTag}

This example [@readme code](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/code_tag.rb) tag embeds the below code snippet via the `{@readme ReadmeYard::CodeTag.format_tag}` markdown tag.

{@readme ReadmeYard::CodeTag.format_tag}

### {@readme ReadmeYard::SourceTag}

**Usage:**

{@example ReadmeYard::SourceTag}

This example [@readme source](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/source_tag.rb) tag embeds the below code snippet via the `{@readme ReadmeYard::SourceTag.format_tag}` markdown tag.

{@readme ReadmeYard::SourceTag.format_tag}

### {@readme ReadmeYard::ValueTag}

**Usage:**

{@example ReadmeYard::ValueTag}

This example [@readme value](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/value_tag.rb) tag embeds the below code snippet via the `{@value ReadmeYard::ValueTag::EXAMPLE}` markdown tag.

{@value ReadmeYard::ValueTag::EXAMPLE}

### {@readme ReadmeYard::StringTag}

**Usage:**

Because a [@readme string](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard/string_tag.rb) tag:

{@example ReadmeYard::StringTag::XZAMPLE}

Is located above this constant:

{@code ReadmeYard::StringTag::XZAMPLE}

We see can see its string value as simple text below:

{@string ReadmeYard::StringTag::XZAMPLE}

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

{@readme ReadmeYard::ExampleTag}

**Usage:**

{@source ReadmeYard::ExampleTag.hello_world}

The below example code is generated from `{@example ReadmeYard::ExampleTag.hello_world}` because, as you can see above, the "hello_world" class method has an `@example` tag.

{@example ReadmeYard::ExampleTag.hello_world}

---

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mattruzicka/yard-readme.

Thanks for reading me, the README that documents how to document the README with code that documents itself 🤯
