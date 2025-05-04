# frozen_string_literal: true

class ReadmeYard
  class TagRegistry
    TAGS = { "readme" => ReadmeTag,
             "example" => ExampleTag,
             "source" => SourceTag,
             "comment" => CommentTag,
             "object" => ObjectTag }.freeze

    def self.find_class(tag_name)
      TAGS[tag_name]
    end

    def self.tag_names
      TAGS.keys
    end
  end
end
