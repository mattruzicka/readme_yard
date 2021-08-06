# frozen_string_literal: true

require "yard-readme"
require_relative "readme_yard/version"

#
# @readme
#   An experiment in building a better README with
#   [YARD](https://yardoc.org).
#   Take a look at [README_YARD.md](https://github.com/mattruzicka/readme_yard/blob/main/README_YARD.md)
#   to see the template from which this README was generated.
#
#   If you're reading the README, that means this text is here
#   because `{@readme ReadmeYard}` is in
#   [README_YARD.md](https://github.com/mattruzicka/readme_yard/blob/main/README_YARD.md)
#   and someone ran `readme build` at the command line.
#
#   If you're looking at the [source code](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb) or
#   [documentation](https://rubydoc.info/github/mattruzicka/readme_yard),
#   _welcome_ to readme yard 🌿 🥏
#
class ReadmeYard
  class Error < StandardError
    class << self
      # TODO: Look for instance method with same name if
      # class method and vise versa to give a more helpful error.
      # Also, look for the object path in other scopes.
      def object_not_found(tag_name, object_path)
        new("`#{object_path}` could not be found. Perhaps" \
            " the `@#{tag_name}` tag was moved, mispelled," \
            " or the `.yardopts` YARD file is missing the file path.")
      end
    end
  end

  #
  # @readme
  #   is used to generate this text in README.md. `ReadmeYard.hello_world` references
  #   the class method located in [lib/readme_yard.rb](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb).
  #
  # @example
  #   ReadmeYard.hello_world => "Hello 🌎 🌍 🌏"
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
    tags = yard_object.tags(:readme)
    "\n#{format_readme_tags(tags)}\n\n"
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
    run_yardoc(options: options)
    File.write(readme_path, gsub_tags!(readme_yard_md))
  end

  #
  # @readme Same as "build" + generates yard docs.
  #
  def doc(options: "-q --markup markdown")
    build(options: options || "-q --markup markdown")
  end

  def run_yardoc(options: "-nq")
    YARD::CLI::Yardoc.run("#{options || "-nq"} --plugin readme")
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

  #
  # This method adds the below paragraph to a project's
  # README.md file, if it doesn't already have one when running
  # `readme build` for the first time.
  #
  # @readme
  #   This is a quick example of using a readme tag in README_YARD.md
  #
  #   > {@readme ReadmeYard#default_readme_yard_md}
  #
  #   to copy a `@readme` comment from
  #   [source code](https://github.com/mattruzicka/readme_yard/blob/main/lib/readme_yard.rb)
  #   and paste it into the README file.
  #
  #   🌱 ⚽
  #
  def default_readme_yard_md
    yard_parse_this_file
    +"Welcome to the README_YARD 🌿 🥏\n\n" \
     "Check out this project's" \
     " [README](https://github.com/mattruzicka/readme_yard#readme)" \
     " for usage.\n\n{@readme ReadmeYard#default_readme_yard_md}"
  end

  def gsub_tags!(markdown)
    markdown.gsub!(/([^`]|^)(\{@\w+\s.+\})/) { |string| format_tag(string) }
    markdown
  end

  def format_tag(string)
    first_char = string[0]
    return string if first_char == "`"

    tag_name = extract_tag_name(string)
    object_path = extract_object_path(string)
    code_object = YARD::Registry.at(object_path)
    raise Error.tag_not_found(tag_name, object_path) unless code_object

    tags = code_object.tags(tag_name)
    return string if tags.empty?

    "#{first_char if first_char != "{"}#{send("format_#{tag_name}_tags", tags)}"
  end

  def extract_tag_name(tag_string)
    tag_string.match(/{@(\w+)\s/).captures.first
  end

  def extract_object_path(tag_string)
    tag_string.match(/\s(\b.+)}/).captures.first
  end

  def format_readme_tags(tags)
    tags.map(&:text).join
  end

  def format_example_tags(tags)
    tags.map { |tag| "```ruby\n#{tag.text}\n```" }.join("\n")
  end

  def yard_parse_this_file
    gem_spec = Gem::Specification.find_by_name("readme_yard")
    current_file_path = File.join(gem_spec.full_gem_path, "lib", "readme_yard.rb")
    YARD.parse(current_file_path)
  end
end
