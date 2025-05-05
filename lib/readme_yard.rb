# frozen_string_literal: true

require "yard"
require "yard-readme"
require "tty-markdown"
require_relative "readme_yard/version"
require_relative "readme_yard/error"
require_relative "readme_yard/logger"
require_relative "readme_yard/readme_tag"
require_relative "readme_yard/example_tag"
require_relative "readme_yard/comment_tag"
require_relative "readme_yard/code_tag"
require_relative "readme_yard/source_tag"
require_relative "readme_yard/value_tag"
require_relative "readme_yard/string_tag"
require_relative "readme_yard/tag_registry"
require_relative "readme_yard/yard_opts_manager"
require "diffy"

YARD::Readme::DocstringParser.readme_tag_names = ReadmeYard::TagRegistry.tag_names

#
# @readme
#   Build a better README with [YARD](https://yardoc.org)
#   by generating it straight from the source.
#
#   This gem aims to minimize the effort needed to keep your
#   README, documentation, and source code synced, useful,
#   and correct. Among its features, it introduces the @readme tag
#   that enables you to embed code comments directly into README sections,
#   eliminating redundancy and keeping documentation consistent
#   across your codebase and project README.
#
#   Look at the [README_YARD.md](https://github.com/mattruzicka/readme_yard/blob/main/README_YARD.md)
#   template for this project to see how it works.
#   If you're reading the README, that means this text is here
#   because the custom `{@readme ReadmeYard}` markdown tag is in
#   README_YARD.md and `readme build` was run at the command line.
#
#   Here's the [full documentation](https://rubydoc.info/github/mattruzicka/readme_yard).
#
class ReadmeYard
  #
  # @see #command_line_usage
  #
  def self.call(arg, options)
    readme_yard = ReadmeYard.new

    case arg
    when "build"
      readme_yard.build(options: options)
    when "yard"
      readme_yard.yard(options: options)
    when "version"
      Logger.puts_md(VERSION)
    else
      Logger.puts_md(readme_yard.command_line_usage)
    end
  rescue Error => e
    Logger.puts_md(e.message)
  end

  def initialize
    @readme_path = "./README.md"
    @readme_yard_path = "./README_YARD.md"
  end

  attr_accessor :readme_path, :readme_yard_path

  #
  # This unnecessarily meta method returns the `@readme` text you see
  # below (if you're reading this in the source code). It was implemented
  # just for fun as a demonstration of @readme tags.
  #
  # @readme
  #   ## Command Line Usage
  #
  #   `readme` - Prints command line usage.
  #
  #   `readme build` - Reads from README_YARD.md and writes to README.md.
  #
  #   `readme yard` - Same as `readme build` + generates yard docs.
  #
  #   `readme version` - Prints the current version of ReadmeYard.
  #
  def command_line_usage
    yard_parse_this_file
    yard_object = YARD::Registry.at("#{self.class.name}##{__method__}")
    yard_tags = yard_object.tags(:readme)
    "\n#{ReadmeTag.format_tags(yard_object, yard_tags)}\n\n"
  end

  #
  # @readme
  #   Reads from README_YARD.md and writes to README.md
  #
  #   Forwards options to yardoc
  #
  # `-n` only generate .yardoc database, no documentation.
  #
  # `-q` silence yardoc output statements
  #
  def build(options: "-nq")
    YARD::CLI::Yardoc.run(options || "-nq")
    old_readme = File.exist?(readme_path) ? File.read(readme_path) : ""
    new_readme = gsub_tags!(readme_yard_md)
    File.write(readme_path, new_readme)
    show_readme_diff(old_readme, new_readme)
  end

  #
  # @readme Same as "build" + generates yard `docs.
  #
  def yard(options: "")
    YardOptsManager.upsert_yardopts
    build(options: options || "")
  end

  private

  def readme_yard_md
    return File.read(readme_yard_path) if File.exist?(readme_yard_path)

    create_new_readme_yard_md
  end

  def create_new_readme_yard_md
    new_readme_yard_md = File.read(readme_path) if File.exist?(readme_path)
    new_readme_yard_md ||= default_readme_yard_md
    File.write(readme_yard_path, new_readme_yard_md)
    new_readme_yard_md
  end

  def default_readme_yard_md
    yard_parse_this_file
    +"Welcome to the README_YARD 🌿 🥏\n\n" \
     "Check out this project's" \
     " [README](https://github.com/mattruzicka/readme_yard#readme)" \
     " for usage.\n\n{@readme ReadmeYard#default_readme_yard_md}"
  end

  def gsub_tags!(markdown)
    markdown.gsub!(/([^`]|^)(\{@\w+\s.+\})/) { |string| format_tag_markdown(string) }
    markdown
  end

  def format_tag_markdown(string)
    first_char = string[0]
    return string if first_char == "`"

    tag_name = extract_tag_name(string)
    object_path = extract_object_path(string)
    yard_object = YARD::Registry.at(object_path)
    raise Error.object_not_found(object_path, tag_name) unless yard_object

    yard_tags_markdown = format_yard_tags_markdown(yard_object, tag_name, string)
    "#{first_char if first_char != "{"}#{yard_tags_markdown}"
  end

  def format_yard_tags_markdown(yard_object, tag_name, string)
    yard_tags = yard_object.tags(tag_name)
    tag_class = TagRegistry.find_class(tag_name)

    if yard_tags.empty?
      if tag_class.respond_to?(:format_yard_object)
        tag_class.format_yard_object(yard_object) || string
      else
        Logger.warn("The `@#{tag_name}` tag is missing from `#{yard_object}`.")
        string
      end
    else
      tag_class.format_tags(yard_object, yard_tags)
    end
  end

  def extract_tag_name(tag_string)
    tag_string.match(/{@(\w+)\s/).captures.first
  end

  def extract_object_path(tag_string)
    tag_string.match(/\s(\b.+)}/).captures.first
  end

  def yard_parse_this_file
    gem_spec = Gem::Specification.find_by_name("readme_yard")
    current_file_path = File.join(gem_spec.full_gem_path, "lib", "readme_yard.rb")
    YARD.parse(current_file_path)
  end

  def show_readme_diff(old_content, new_content)
    if old_content == new_content
      Logger.puts_md("\n**No changes** to README.md\n\n")
      return
    end

    diff = Diffy::Diff.new(old_content, new_content, context: 0).to_s(:color)
    Logger.puts_md("\n**Changes to README.md:**\n\n")
    Logger.puts_text "#{diff}\n"
  end
end
