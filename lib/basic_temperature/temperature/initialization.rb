# frozen_string_literal: true

module BasicTemperature
  class Temperature
    module Initialization
      private

      def initialize_via_positional_arguments(positional_arguments)
        degrees, scale = positional_arguments

        initialize_arguments(degrees, scale)
      end

      def initialize_via_keywords_arguments(keyword_arguments)
        degrees, scale = keyword_arguments.values_at(:degrees, :scale)

        initialize_arguments(degrees, scale)
      end

      def initialize_arguments(degrees, scale)
        casted_degrees = cast_degrees(degrees)
        casted_scale = cast_scale(scale)

        assert_valid_degrees!(casted_degrees)
        assert_valid_scale!(casted_scale)

        @degrees = casted_degrees
        @scale = casted_scale
      end
    end
  end
end
