# frozen_string_literal: true

class ReadmeYard
  class Logger
    class << self
      def warn(msg)
        msg = "Warning: #{msg}"
        puts TTY::Markdown.parse(msg)
      end
    end
  end
end
