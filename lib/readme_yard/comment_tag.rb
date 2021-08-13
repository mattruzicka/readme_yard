class ReadmeYard
  #
  # @readme
  #   Embed comments
  #
  # @example
  #   # @readme comment
  #
  class CommentTag
    class << self
      #
      # This comment is in the README because `@readme comment`
      # is below (in the source code).
      #
      # @readme comment
      #
      def format_tag_markdown(yard_object, _tag)
        comment = format_docstring_as_comment(yard_object)
        ExampleTag.format_ruby(comment)
      end

      #
      # @see https://rubydoc.info/gems/yard/YARD%2FDocstring:to_raw
      #
      def format_docstring_as_comment(yard_object)
        comment = +""
        docstring = yard_object.docstring.all
        docstring.gsub!(named_readme_tag_regex, "")
        docstring.lines.each do |line|
          comment << "#"
          comment << " " unless line[0] == "\n"
          comment << line
        end
        last_line = yard_object.docstring.all.lines.last
        comment << "#" if last_line.match?(/\n$/)
        comment
      end

      def named_readme_tag_regex
        @named_readme_tag_regex ||= /(\n|^)@readme\s(#{YARDReadme::DocstringParser.readme_tag_names.join("|")})\n/
      end
    end
  end
end
