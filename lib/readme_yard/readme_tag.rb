# frozen_string_literal: true

class ReadmeYard
  #
  # @readme
  #   By default, only the text nested under a @readme tag
  #   will be embedded in the final output. The default
  #   embed behavior can be changed through the use of tag names.
  #
  # @see ReadmeYard::CommentTag
  # @see ReadmeYard::CodeTag
  # @see ReadmeYard::SourceTag
  # @see ReadmeYard::ValueTag
  # @see ReadmeYard::StringTag
  #
  class ReadmeTag
    class << self
      def format_tags(yard_object, yard_tags)
        md = +""
        yard_tags.each do |tag|
          res = format_yard_tag(yard_object, tag)
          md << res if res
        end
        md
      end

      def format_tag(_yard_object, tag)
        "#{tag.text}\n"
      end

      private

      def format_yard_tag(yard_object, tag)
        if tag.name && !tag.name.empty?
          tag_class = TagRegistry.find_class(tag.name)
          tag_class&.format_tag(yard_object, tag)
        elsif tag.text && !tag.text.empty?
          format_tag(yard_object, tag)
        else
          Logger.warn("Empty `@readme` tag found in `#{yard_object}`.")
        end
      end
    end
  end
end
