class ReadmeYard
  class ExampleTag
    class << self
      def format_markdown(yard_object, yard_tags)
        yard_tags.map { |tag| format_tag_markdown(yard_object, tag) }.join("\n")
      end

      def format_tag_markdown(yard_object, tag)
        text = tag.text.empty? ? yard_object.source : tag.text
        format_ruby(text)
      end

      def format_ruby(text)
        "```ruby\n#{text}\n```\n"
      end
    end
  end
end
