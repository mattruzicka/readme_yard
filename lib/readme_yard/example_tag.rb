# frozen_string_literal: true

class ReadmeYard
  #
  # @readme
  #   The Example Tag leverages YARD's standard `@example` tag syntax, allowing you to
  #   include example code in your README directly from source files. This saves time and
  #   ensures your README stays in sync with your YARD documentation
  #
  class ExampleTag
    class << self
      #
      # @readme source
      #
      # @example
      #   ReadmeYard::ExampleTag.hello_world #=> "Hello 🌎 🌍 🌏"
      #
      def hello_world
        "Hello 🌎 🌍 🌏"
      end

      def format_tags(yard_object, yard_tags)
        yard_tags.map { |tag| format_tag(yard_object, tag) }.join("\n")
      end

      def format_tag(yard_object, tag)
        text = tag.text.empty? ? yard_object.source : tag.text
        format_ruby(text)
      end

      def format_ruby(text)
        "```ruby\n#{text}\n```\n"
      end
    end
  end
end
