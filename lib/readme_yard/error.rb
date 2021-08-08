class ReadmeYard
  class Error < StandardError
    class << self
      #
      # @todo
      #   Look for instance method with same name if
      #   class method and vise versa to give a more helpful error.
      #   Look for the object path in other scopes.
      #
      def object_not_found(object_path, tag_name)
        new("*Readme Yard* could not find `#{object_path}`. Perhaps" \
            " the `@#{tag_name}` tag was moved, mispelled," \
            " or the `.yardopts` YARD file is missing the file path.")
      end
    end
  end
end
