# frozen_string_literal: true

module BasicTemperature
  class Temperature
    module Errors
      # Raised when <tt>Temperature.new</tt> is called with mixed positional and keyword arguments or without
      # arguments at all.
      class InitializationArguments < StandardError; end

      # Raised when <tt>degrees</tt> is not a Numeric.
      class InvalidDegrees < StandardError; end

      # Raised when <tt>scale</tt> can not be casted to any possible scale value.
      # See {SCALES}[rdoc-ref:Temperature::SCALES].
      class InvalidScale < StandardError; end

      # Raised when <tt>other</tt> is neither Numeric nor Temperature in math operations.
      class InvalidNumericOrTemperature < StandardError; end

      # Raised when <tt>other</tt> is not a Numeric in math operations.
      class InvalidNumeric < StandardError; end

      private

      def raise_initialization_arguments_error
        message =
          'Positional and keyword arguments are mixed or ' \
          'neither positional nor keyword arguments are passed.'

        raise InitializationArguments, message
      end

      def raise_invalid_degrees_error
        raise InvalidDegrees, 'degree is NOT a numeric value.'
      end

      def raise_invalid_scale_error
        message =
          'scale has invalid value, ' \
          "valid values are #{SCALES.map { |scale| "'#{scale}'" }.join(', ')}."

        raise InvalidScale, message
      end

      def raise_invalid_numeric(numeric)
        raise InvalidNumeric, "`#{numeric}` is not a Numeric."
      end
    end
  end
end
