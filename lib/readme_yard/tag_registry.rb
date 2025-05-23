# frozen_string_literal: true

class ReadmeYard
  class TagRegistry
    TAGS = { "readme" => ReadmeTag,
             "example" => ExampleTag,
             "code" => CodeTag,
             "source" => SourceTag,
             "comment" => CommentTag,
             "value" => ValueTag,
             "string" => StringTag }.freeze

    def self.find_class(tag_name)
      TAGS[tag_name.downcase]
    end

    def self.tag_names
      TAGS.keys
    end
  end
end
