# frozen_string_literal: true

class ReadmeYard
  #
  # @readme
  #   Embed Ruby code
  #
  # @example
  #   # @readme code
  #
  class CodeTag
    class << self
      #
      # The code for this method is in the README because
      # `@readme code` is below (in the source code).
      #
      # @readme code
      #
      def format_tag(yard_object, _tag)
        ExampleTag.format_ruby(yard_object.source)
      end

      def format_yard_object(yard_object)
        format_tag(yard_object, nil)
      end
    end
  end
end
