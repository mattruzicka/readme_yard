# frozen_string_literal: true

require "yard-readme"
require_relative "readme_yard/version"
require_relative "readme_yard/error"
require_relative "readme_yard/logger"
require_relative "readme_yard/readme_tag"
require_relative "readme_yard/example_tag"
require_relative "readme_yard/comment_tag"
require_relative "readme_yard/source_tag"
require_relative "readme_yard/object_tag"

YARDReadme::DocstringParser.readme_tag_names = %w[comment source object]

#
# @readme
#   Build a better README with [YARD](https://yardoc.org),
#   one that summarizes and contextualizes the code and documentation,
#   without duplicating them.
#
#   This gem aims to minimize the effort needed to keep
#   your code, docs, and README useful, syncd, and correct.
#
#   For a glimpse of how it works, check out the [README_YARD.md](https://github.com/mattruzicka/readme_yard/blob/main/README_YARD.md)
#   template from which this gem's README was generated.
#   If you're reading the README, that means this text is here
#   because `{@readme ReadmeYard}` is in the README_YARD file
#   and someone ran `readme build` at the command line.
#
#   Here's the [full documentation](https://rubydoc.info/github/mattruzicka/readme_yard).
#
class ReadmeYard
  #
  # @readme comment
  #
  # @example
  #   ReadmeYard.hello_world #=> "Hello 🌎 🌍 🌏"
  #
  def self.hello_world
    "Hello 🌎 🌍 🌏"
  end

  #
  # @see #command_line_usage
  #
  def self.call(arg, options)
    readme_yard = ReadmeYard.new

    case arg
    when "build"
      readme_yard.build(options: options)
    when "doc"
      readme_yard.doc(options: options)
    else
      puts TTY::Markdown.parse(readme_yard.command_line_usage)
    end
  rescue Error => e
    puts TTY::Markdown.parse(e.message)
  end

  TAG_CLASS_LOOKUP = { "readme" => ReadmeTag,
                       "example" => ExampleTag,
                       "source" => SourceTag,
                       "comment" => CommentTag,
                       "object" => ObjectTag }.freeze

  def self.lookup_tag_class(tag_name)
    TAG_CLASS_LOOKUP[tag_name]
  end

  def initialize
    @readme_path = "./README.md"
    @readme_yard_path = "./README_YARD.md"
  end

  attr_accessor :readme_path, :readme_yard_path

  #
  # This method returns the following `@readme` text
  #
  # @readme
  #   ## Command Line Usage
  #
  #   `readme` - Prints command line usage.
  #
  #   `readme build` - Reads from README_YARD.md and writes to README.md.
  #
  #   `readme doc` - Same as `readme build` + generates yard docs.
  #
  def command_line_usage
    yard_parse_this_file
    yard_object = YARD::Registry.at("#{self.class.name}##{__method__}")
    yard_tags = yard_object.tags(:readme)
    "\n#{ReadmeTag.format_markdown(yard_object, yard_tags)}\n\n"
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
    find_or_upsert_yardopts
    run_yardoc(options: options)
    File.write(readme_path, gsub_tags!(readme_yard_md))
  end

  #
  # @readme Same as "build" + generates yard docs.
  #
  def doc(options: "-q")
    build(options: options || "-q")
  end

  def run_yardoc(options: "-nq")
    YARD::CLI::Yardoc.run(options || "-nq")
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

  YARDOPTS_FILE = ".yardopts"

  def find_or_upsert_yardopts
    File.exist?(YARDOPTS_FILE) ? update_yardopts_file : create_yardopts_file
  end

  def update_yardopts_file
    text = File.read(YARDOPTS_FILE)
    text_addition = build_yardopts_text_addition(text)
    File.open(YARDOPTS_FILE, "a") { |f| f.write(text_addition) } if text_addition
  end

  def build_yardopts_text_addition(yardopts_text)
    return if yardopts_text.match?(/\s*--plugin\s+readme\W/)

    readme_plugin_opts = default_readme_plugin_opts(yardopts_text)
    case yardopts_text
    when /\s*--markup\s+markdown/, /\s*-m\s+markdown/
      readme_plugin_opts
    when /\s*--markup\s/, /\s*-m\s/
      warn_about_supported_markdown
      readme_plugin_opts
    else
      readme_plugin_opts << "--markup markdown\n"
    end
  end

  def default_readme_plugin_opts(yardopts_text)
    readme_opts = +""
    readme_opts << "\n" unless yardopts_text.lines.last.include?("\n")
    readme_opts << "--plugin readme\n"
  end

  def create_yardopts_file
    File.write(YARDOPTS_FILE, "--plugin readme\n--markup markdown\n")
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
    if yard_tags.empty?
      warn_about_yard_tags_not_found(yard_object, tag_name)
      string
    else
      tag_class = self.class.lookup_tag_class(tag_name)
      tag_class.format_markdown(yard_object, yard_tags)
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

  def warn_about_supported_markdown
    Logger.warn "\n*Readme Yard* works best with markdown." \
                "\nConsider adding `--markup markdown` to your `.yardopts` file.\n\n"
  end

  def warn_about_yard_tags_not_found(yard_object, tag_name)
    Logger.warn "The `@#{tag_name}` *Readme Yard* tag is missing from #{yard_object}."
  end
end
