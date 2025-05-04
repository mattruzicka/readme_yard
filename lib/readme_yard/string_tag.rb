# frozen_string_literal: true

class ReadmeYard
  #
  # @readme
  #   Embed a Ruby string as normal text
  #
  class StringTag
    #
    # @example
    #   # @readme string
    #
    # @readme string
    #
    EXAMPLE_USAGE = "This string will show up as simple text in the README"

    class << self
      def format_tag(yard_object, _tag)
        if yard_object.respond_to?(:value)
          string_value = yard_object.value.dup
          string_value.delete_prefix!('"')
          string_value.delete_suffix!('"')
          string_value
        else
          Logger.warn("Cannot parse `@readme string`: #{yard_object.class.name} lacks `value` method.")
        end
      end

      def format_yard_object(yard_object)
        format_tag(yard_object, nil)
      end
    end
  end
end
