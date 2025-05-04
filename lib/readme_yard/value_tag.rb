# frozen_string_literal: true

class ReadmeYard
  #
  # @readme
  #   Embed a Ruby value as a Ruby code block
  #
  # @example
  #   # @readme value
  #
  class ValueTag
    #
    # @readme value
    #
    EXAMPLE = { key: "value" }.freeze

    class << self
      def format_tag(yard_object, _tag)
        if yard_object.respond_to?(:value)
          "```ruby\n#{yard_object.value}\n```"
        else
          Logger.warn("Cannot parse `@readme value`: #{yard_object.class.name} lacks `value` method.")
        end
      end

      def format_yard_object(yard_object)
        format_tag(yard_object, nil)
      end
    end
  end
end
