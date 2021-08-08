class ReadmeYard
  #
  # @readme
  #   ```@readme source``` - Embeds the source.
  #
  class SourceTag
    class << self
      #
      # The following tag embeds this method's source.
      #
      # @readme source
      #
      def format_tag_markdown(yard_object, _tag)
        ExampleTag.format_ruby(yard_object.source)
      end
    end
  end
end
