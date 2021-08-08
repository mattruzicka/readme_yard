class ReadmeYard
  #
  # @readme
  #   ```@readme object``` - Embeds the comment and source.
  #
  class ObjectTag
    class << self
      #
      # This method's comment and code is in the README because
      # `@readme object` is below (in the source code).
      #
      # @readme object
      #
      def format_tag_markdown(yard_object, _tag)
        text = CommentTag.format_docstring_as_comment(yard_object)
        text << "\n#{yard_object.source}"
        ExampleTag.format_ruby(text)
      end
    end
  end
end
