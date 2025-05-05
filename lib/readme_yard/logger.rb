# frozen_string_literal: true

class ReadmeYard
  class Logger
    class << self
      def warn(msg)
        msg = "Warning: #{msg}"
        puts_md(msg)
      end

      def puts_md(msg)
        puts TTY::Markdown.parse(msg)
      end

      def puts_text(msg)
        puts msg
      end
    end
  end
end
