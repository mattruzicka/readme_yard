# frozen_string_literal: true

class ReadmeYard
  #
  # @readme
  #   Embed Ruby comments and code
  #
  # @example
  #   # @readme source
  #
  class SourceTag
    class << self
      #
      # The comment and code for ReadmeYard::SourceTag#format_tag
      # is in the README because `@readme source` is below (in the source code).
      #
      # @readme source
      #
      def format_tag(yard_object, _tag)
        text = CommentTag.format_docstring_as_comment(yard_object)
        text << "\n#{yard_object.source}"
        ExampleTag.format_ruby(text)
      end

      def format_yard_object(yard_object)
        format_tag(yard_object, nil)
      end
    end
  end
end
