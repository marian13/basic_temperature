# frozen_string_literal: true

module BasicTemperature
  class Temperature
    module Assertions
      private

      def assert_either_positional_arguments_or_keyword_arguments!(positional_arguments, keyword_arguments)
        raise_initialization_arguments_error if positional_arguments.any? && keyword_arguments.any?
        raise_initialization_arguments_error if positional_arguments.none? && keyword_arguments.none?
      end

      def assert_valid_degrees!(degrees)
        raise_invalid_degrees_error unless degrees.is_a?(Numeric)
      end

      def assert_valid_scale!(scale)
        raise_invalid_scale_error unless SCALES.include?(scale)
      end

      def assert_numeric_or_temperature!(numeric_or_temperature)
        return if numeric_or_temperature.is_a?(Numeric) || numeric_or_temperature.instance_of?(Temperature)

        raise_invalid_numeric_or_temperature_error(numeric_or_temperature)
      end

      def assert_numeric!(numeric)
        raise_invalid_numeric(numeric) unless numeric.is_a?(Numeric)
      end

      def assert_temperature(temperature)
        temperature.instance_of?(Temperature)
      end
    end
  end
end
