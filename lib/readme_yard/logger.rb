class ReadmeYard
  class Logger
    class << self
      def warn(msg)
        puts TTY::Markdown.parse(msg)
      end
    end
  end
end