# frozen_string_literal: true

class ReadmeYard
  #
  # @readme
  #   Embed a Ruby string as normal text
  #
  class StringTag
    #
    # @example
    #   # @readme string
    #
    # @readme string
    #
    XZAMPLE = <<~STRING
      I heard you like self-documenting Ruby, so I wrote
      self-documenting Ruby for your self-documenting Ruby.
    STRING

    class << self
      def format_tag(yard_object, _tag)
        if yard_object.respond_to?(:value)
          normalize_yard_value(yard_object.value)
        else
          Logger.warn("Cannot parse `@readme string`: #{yard_object.class.name} lacks `value` method.")
        end
      end

      def format_yard_object(yard_object)
        format_tag(yard_object, nil)
      end

      def normalize_yard_value(string_value)
        return "" if string_value.nil? || string_value.empty?

        string_value = string_value.dup

        # Handle heredoc format
        return normalize_value_for_heredoc(string_value) if string_value.strip.start_with?("<<~")

        # Handle regular string format
        if string_value.start_with?('"')
          string_value.delete_prefix!('"')
          string_value.delete_suffix!('"')
        elsif string_value.start_with?("'")
          string_value.delete_prefix!("'")
          string_value.delete_suffix!("'")
        end

        # Replace different line continuation patterns
        # This handles patterns like: " \\\n" and \\\n"
        string_value.gsub!(/" \\\n"/, "")
        string_value.gsub!(/\\\n\s*"/, "")
        string_value.gsub!(/"\\\n"/, "")
        string_value.gsub!(/"\\\n/, "")

        # Unescape common escape sequences
        string_value.gsub!(/\\n/, "\n")
        string_value.gsub!(/\\t/, "\t")
        string_value.gsub!(/\\r/, "\r")
        string_value.gsub!(/\\"/, '"')
        string_value.gsub!(/\\'/, "'")
        string_value.gsub!(/\\\\/, "\\")
        string_value
      end

      private

      def normalize_value_for_heredoc(string_value)
        # Extract the content between the heredoc delimiters
        lines = string_value.lines
        delimiter = lines.first.strip.gsub(/<<~/, "").strip
        content_lines = []

        in_content = false
        lines.each do |line|
          if in_content && line.strip == delimiter
            break
          elsif in_content
            content_lines << line
          elsif line.strip.start_with?("<<~")
            in_content = true
          end
        end

        # Return the joined content with proper indentation removed
        content_lines.join.gsub(/^\s+/, "").strip
      end
    end
  end
end
