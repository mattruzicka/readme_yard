class ReadmeYard
  #
  # @readme
  #   By default, only the text nested under a @readme tag
  #   will be embedded in the final output. The default
  #   embed behavior can be changed through the use of tag names.
  #
  # @see ReadmeYard::CommentTag
  # @see ReadmeYard::SourceTag
  # @see ReadmeYard::ObjectTag
  #
  class ReadmeTag
    class << self
      def format_markdown(yard_object, yard_tags)
        md = +""
        yard_tags.each do |tag|
          res = format_yard_tag(yard_object, tag)
          md << res if res
        end
        md
      end

      def format_tag_markdown(_yard_object, tag)
        "#{tag.text}\n"
      end

      private

      def format_yard_tag(yard_object, tag)
        if tag.name && !tag.name.empty?
          tag_class = ReadmeYard.lookup_tag_class(tag.name)
          tag_class&.format_tag_markdown(yard_object, tag)
        elsif tag.text && !tag.text.empty?
          format_tag_markdown(yard_object, tag)
        end
      end
    end
  end
end
