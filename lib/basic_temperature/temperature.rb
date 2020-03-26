# frozen_string_literal: true

require_relative 'temperature/additional_helpers'
require_relative 'temperature/assertions'
require_relative 'temperature/casting'
require_relative 'temperature/errors'
require_relative 'temperature/initialization'
require_relative 'temperature/memoization'
require_relative 'temperature/rounding'

module BasicTemperature
  # rubocop:disable Metrics/ClassLength

  ##
  # Temperature is a simple {Value Object}[https://martinfowler.com/bliki/ValueObject.html] for basic
  # temperature operations like conversions from <tt>Celsius</tt> to <tt>Fahrenhait</tt> or <tt>Kelvin</tt>
  # etc.
  #
  # Supported scales: <tt>Celsius</tt>, <tt>Fahrenheit</tt>, <tt>Kelvin</tt> and <tt>Rankine</tt>.
  #
  # == Creating Temperatures
  #
  # A new temperature can be created in multiple ways:
  #
  # - Using keyword arguments:
  #
  #     Temperature.new(degrees: 0, scale: :celsius)
  #
  # - Using positional arguments:
  #
  #     Temperature.new(0, :celsius)
  #
  # - Even more concise way using <tt>Temperature.[]</tt> (an alias of <tt>Temperature.new</tt>):
  #
  #     Temperature[0, :celsius]
  #
  #
  # == Creating Temperatures from already existing temperature objects
  #
  # Sometimes it is useful to create a new temperature from already existing one.
  #
  # For such cases, there are {set_degrees}[rdoc-ref:Temperature#set_degrees and
  # {set_scale}[rdoc-ref:Temperature#set_scale].
  #
  # Since temperatures are {Value Objects}[https://martinfowler.com/bliki/ValueObject.html], both methods
  # returns new instances.
  #
  # Examples:
  #
  #   temperature = Temperature[0, :celsius]
  #   # => 0 °C
  #
  #   new_temperature = temperature.set_degrees(15)
  #   # => 15 °C
  #
  #   temperature = Temperature[0, :celsius]
  #   # => 0 °C
  #
  #   new_temperature = temperature.set_scale(:kelvin)
  #   # => 0 K
  #
  # == Conversions
  #
  # Temperatures can be converted to diffirent scales.
  #
  # Currently, the following scales are supported: <tt>Celsius</tt>, <tt>Fahrenheit</tt>, <tt>Kelvin</tt> and
  # <tt>Rankine</tt>.
  #
  #   Temperature[20, :celsius].to_celsius
  #   # => 20 °C
  #
  #   Temperature[20, :celsius].to_fahrenheit
  #   # => 68 °F
  #
  #   Temperature[20, :celsius].to_kelvin
  #   # => 293.15 K
  #
  #   Temperature[20, :celsius].to_rankine
  #   # => 527.67 °R
  #
  # If it is necessary to convert scale dynamically, {to_scale}[rdoc-ref:Temperature#to_scale] method is
  # available.
  #
  #   Temperature[20, :celsius].to_scale(scale)
  #
  # All conversion formulas are taken from
  # {RapidTables}[https://www.rapidtables.com/convert/temperature/index.html].
  #
  # Conversion precision: 2 accurate digits after the decimal dot.
  #
  # == Comparison
  #
  # Temperature implements idiomatic {<=> spaceship operator}[https://ruby-doc.org/core/Comparable.html] and
  # mixes in {Comparable}[https://ruby-doc.org/core/Comparable.html] module.
  #
  # As a result, all methods from Comparable are available, e.g:
  #
  #   Temperature[20, :celsius] < Temperature[25, :celsius]
  #   # => true
  #
  #   Temperature[20, :celsius] <= Temperature[25, :celsius]
  #   # => true
  #
  #   Temperature[20, :celsius] == Temperature[25, :celsius]
  #   # => false
  #
  #   Temperature[20, :celsius] > Temperature[25, :celsius]
  #   # => false
  #
  #   Temperature[20, :celsius] >= Temperature[25, :celsius]
  #   # => false
  #
  #   Temperature[20, :celsius].between?(Temperature[15, :celsius], Temperature[25, :celsius])
  #   # => true
  #
  #   # Starting from Ruby 2.4.6
  #   Temperature[20, :celsius].clamp(Temperature[20, :celsius], Temperature[25, :celsius])
  #   # => 20 °C
  #
  # Please note, if <tt>other</tt> temperature has a different scale, temperature is automatically converted
  # to that scale before comparison.
  #
  #   Temperature[20, :celsius] == Temperature[293.15, :kelvin]
  #   # => true
  #
  # IMPORTANT !!!
  #
  # <tt>degrees</tt> are rounded to the nearest value with a precision of 2 decimal digits before comparison.
  #
  # This means the following temperatures are considered as equal:
  #
  #   Temperature[20.020, :celsius] == Temperature[20.024, :celsius]
  #   # => true
  #
  #   Temperature[20.025, :celsius] == Temperature[20.029, :celsius]
  #   # => true
  #
  # while these ones are treated as NOT equal:
  #
  #   Temperature[20.024, :celsius] == Temperature[20.029, :celsius]
  #   # => false
  #
  # == Math
  #
  # ==== Addition/Subtraction.
  #
  #   Temperature[20, :celsius] + Temperature[10, :celsius]
  #   # => 30 °C
  #
  #   Temperature[20, :celsius] - Temperature[10, :celsius]
  #   # => 10 °C
  #
  # If second temperature has a different scale, first temperature is automatically converted to that scale
  # before <tt>degrees</tt> addition/subtraction.
  #
  #   Temperature[283.15, :kelvin] + Temperature[10, :celsius]
  #   # => 10 °C
  #
  # Returned temperature will have the same scale as the second temperature.
  #
  # It is possible to add/subtract numerics.
  #
  #   Temperature[20, :celsius] + 10
  #   # => 30 °C
  #
  #   Temperature[20, :celsius] - 10
  #   # => 10 °C
  #
  # In such cases, returned temperature will have the same scale as the first temperature.
  #
  # Also {Ruby coersion mechanism}[https://ruby-doc.org/core/Numeric.html#method-i-coerce] is supported.
  #
  #   10 + Temperature[20, :celsius]
  #   # => 30 °C
  #
  #   10 - Temperature[20, :celsius]
  #   # => -10 °C
  #
  # ==== Negation
  #
  #   -Temperature[20, :celsius]
  #   # => -20 °C
  #
  class Temperature
    include Comparable

    include AdditionalHelpers
    include Assertions
    include Casting
    include Errors
    include Initialization
    include Memoization
    include Rounding

    CELSIUS    = 'celsius'
    FAHRENHEIT = 'fahrenheit'
    KELVIN     = 'kelvin'
    RANKINE    = 'rankine'

    # A list of all currently supported scale values.
    SCALES = [CELSIUS, FAHRENHEIT, KELVIN, RANKINE].freeze

    # Degrees of the temperature.
    attr_reader :degrees

    # Scale of the temperature. Look at {SCALES}[rdoc-ref:Temperature::SCALES] for possible values.
    attr_reader :scale

    ##
    # Creates a new instance of Temperature. Alias for <tt>new</tt>.
    #
    # :call-seq:
    #   [](degrees:, scale:)
    #   [](degrees, scale)
    #
    def self.[](*args, **kwargs)
      new(*args, **kwargs)
    end

    ##
    # Creates a new instance of Temperature. Is aliased as <tt>[]</tt>.
    #
    # :call-seq:
    #   new(degrees:, scale:)
    #   new(degrees, scale)
    #
    def initialize(*positional_arguments, **keyword_arguments)
      assert_either_positional_arguments_or_keyword_arguments!(positional_arguments, keyword_arguments)

      if keyword_arguments.any?
        initialize_via_keywords_arguments(keyword_arguments)
      else # positional_arguments.any?
        initialize_via_positional_arguments(positional_arguments)
      end
    end

    # rubocop:disable Naming/AccessorMethodName

    # Returns a new Temperature with updated <tt>degrees</tt>.
    #
    #   temperature = Temperature[0, :celsius]
    #   # => 0 °C
    #
    #   new_temperature = temperature.set_degrees(15)
    #   # => 15 °C
    #
    def set_degrees(degrees)
      Temperature.new(degrees, scale)
    end
    # rubocop:enable Naming/AccessorMethodName

    # rubocop:disable Naming/AccessorMethodName

    # Returns a new Temperature with updated <tt>scale</tt>.
    #
    #   temperature = Temperature[0, :celsius]
    #   # => 0 °C
    #
    #   new_temperature = temperature.set_scale(:kelvin)
    #   # => 0 K
    #
    def set_scale(scale)
      Temperature.new(degrees, scale)
    end
    # rubocop:enable Naming/AccessorMethodName

    ##
    # Converts temperature to specific <tt>scale</tt>.
    # If temperature is already in desired <tt>scale</tt>, returns current temperature object.
    #
    # Raises {InvalidScaleError}[rdoc-ref:Temperature::InvalidScaleError]
    # when <tt>scale</tt> can not be casted to any possible scale value
    # (see {SCALES}[rdoc-ref:Temperature::SCALES]).
    #
    #   Temperature[60, :fahrenheit].to_scale(:celsius)
    #   # => 15.56 °C
    #
    def to_scale(scale)
      casted_scale = cast_scale(scale)

      assert_valid_scale!(casted_scale)

      case casted_scale
      when CELSIUS
        to_celsius
      when FAHRENHEIT
        to_fahrenheit
      when KELVIN
        to_kelvin
      when RANKINE
        to_rankine
      end
    end

    ##
    # Converts temperature to Celsius scale. If temperature is already in Celsius, returns current
    # temperature object.
    #
    # Memoizes subsequent calls.
    #
    # Conversion formulas are taken from {RapidTables}[https://www.rapidtables.com/]:
    # 1. {Celsius to Fahrenheit}[https://www.rapidtables.com/convert/temperature/celsius-to-fahrenheit.html].
    # 2. {Celsius to Kelvin}[https://www.rapidtables.com/convert/temperature/celsius-to-kelvin.html].
    # 3. {Celsius to Rankine}[https://www.rapidtables.com/convert/temperature/celsius-to-rankine.html].
    #
    #   Temperature[0, :fahrenheit].to_celsius
    #   # => -17.78 °C
    #
    def to_celsius
      memoized(:to_celsius) || memoize(:to_celsius, -> {
        return self if self.scale == CELSIUS

        degrees =
          case self.scale
          when FAHRENHEIT
            (self.degrees - 32) * (5 / 9r)
          when KELVIN
            self.degrees - 273.15
          when RANKINE
            (self.degrees - 491.67) * (5 / 9r)
          end

        Temperature.new(degrees, CELSIUS)
      })
    end

    ##
    # Converts temperature to Fahrenheit scale. If temperature is already in Fahrenheit, returns current
    # temperature object.
    #
    # Memoizes subsequent calls.
    #
    # Conversion formulas are taken from {RapidTables}[https://www.rapidtables.com/]:
    # 1. {Fahrenheit to Celsius}[https://www.rapidtables.com/convert/temperature/fahrenheit-to-celsius.html].
    # 2. {Fahrenheit to Kelvin}[https://www.rapidtables.com/convert/temperature/fahrenheit-to-kelvin.html].
    # 3. {Fahrenheit to Rankine}[https://www.rapidtables.com/convert/temperature/fahrenheit-to-rankine.html].
    #
    #   Temperature[0, :celsius].to_fahrenheit
    #   # => 32 °F
    #
    def to_fahrenheit
      memoized(:to_fahrenheit) || memoize(:to_fahrenheit, -> {
        return self if self.scale == FAHRENHEIT

        degrees =
          case self.scale
          when CELSIUS
            self.degrees * (9 / 5r) + 32
          when KELVIN
            self.degrees * (9 / 5r) - 459.67
          when RANKINE
            self.degrees - 459.67
          end

        Temperature.new(degrees, FAHRENHEIT)
      })
    end

    ##
    # Converts temperature to Kelvin scale. If temperature is already in Kelvin, returns current
    #  temperature object.
    #
    # Memoizes subsequent calls.
    #
    # Conversion formulas are taken from {RapidTables}[https://www.rapidtables.com/]:
    # 1. {Kelvin to Celsius}[https://www.rapidtables.com/convert/temperature/kelvin-to-celsius.html].
    # 2. {Kelvin to Fahrenheit}[https://www.rapidtables.com/convert/temperature/kelvin-to-fahrenheit.html].
    # 3. {Kelvin to Rankine}[https://www.rapidtables.com/convert/temperature/kelvin-to-rankine.html].
    #
    #   Temperature[0, :kelvin].to_rankine
    #   # => 0 °R
    #
    def to_kelvin
      memoized(:to_kelvin) || memoize(:to_kelvin, -> {
        return self if self.scale == KELVIN

        degrees =
          case self.scale
          when CELSIUS
            self.degrees + 273.15
          when FAHRENHEIT
            (self.degrees + 459.67) * (5 / 9r)
          when RANKINE
            self.degrees * (5 / 9r)
          end

        Temperature.new(degrees, KELVIN)
      })
    end

    ##
    # Converts temperature to Rankine scale. If temperature is already in Rankine, returns current
    # temperature object.
    #
    # Memoizes subsequent calls.
    #
    # Conversion formulas are taken from {RapidTables}[https://www.rapidtables.com/]:
    # 1. {Rankine to Celsius}[https://www.rapidtables.com/convert/temperature/rankine-to-celsius.html].
    # 2. {Rankine to Fahrenheit}[https://www.rapidtables.com/convert/temperature/rankine-to-fahrenheit.html].
    # 3. {Rankine to Kelvin}[https://www.rapidtables.com/convert/temperature/rankine-to-kelvin.html].
    #
    #   Temperature[0, :rankine].to_kelvin
    #   # => 0 K
    #
    def to_rankine
      memoized(:to_rankine) || memoize(:to_rankine, -> {
        return self if self.scale == RANKINE

        degrees =
          case self.scale
          when CELSIUS
            (self.degrees + 273.15) * (9 / 5r)
          when FAHRENHEIT
            self.degrees + 459.67
          when KELVIN
            self.degrees * (9 / 5r)
          end

        Temperature.new(degrees, RANKINE)
      })
    end

    ##
    # Compares temperture with <tt>other</tt> temperature.
    #
    # Returns <tt>0</tt> if they are considered as equal.
    #
    # Two temperatures are considered as equal when they have the same amount of <tt>degrees</tt>.
    #
    # Returns <tt>-1</tt> if temperature is lower than <tt>other</tt> temperature.
    #
    # Returns <tt>1</tt> if temperature is higher than <tt>other</tt> temperature.
    #
    # If <tt>other</tt> temperature has a different scale, temperature is automatically converted to that
    # scale before <tt>degrees</tt> comparison.
    #
    #   Temperature[20, :celsius] <=> Temperature[20, :celsius]
    #   # => 0
    #
    #   Temperature[20, :celsius] <=> Temperature[293.15, :kelvin]
    #   # => 0
    #
    # IMPORTANT!!!
    #
    # This method rounds <tt>degrees</tt> to the nearest value with a precision of 2 decimal digits.
    #
    # This means the following:
    #
    #   Temperature[20.020, :celsius] <=> Temperature[20.024, :celsius]
    #   # => 0
    #
    #   Temperature[20.025, :celsius] <=> Temperature[20.029, :celsius]
    #   # => 0
    #
    #   Temperature[20.024, :celsius] <=> Temperature[20.029, :celsius]
    #   # => -1
    #
    def <=>(other)
      return unless assert_temperature(other)

      round_degrees(self.to_scale(other.scale).degrees) <=> round_degrees(other.degrees)
    end

    ##
    # Performs addition. Returns a new Temperature.
    #
    #   Temperature[20, :celsius] + Temperature[10, :celsius]
    #   # => 30 °C
    #
    # If the second temperature has a different scale, the first temperature is automatically converted to
    # that scale before <tt>degrees</tt> addition.
    #
    #   Temperature[283.15, :kelvin] + Temperature[20, :celsius]
    #   # => 30 °C
    #
    # Returned temperature will have the same scale as the second temperature.
    #
    # It is possible to add numerics.
    #
    #   Temperature[20, :celsius] + 10
    #   # => 30 °C
    #
    # In such cases, returned temperature will have the same scale as the first temperature.
    #
    # Also {Ruby coersion mechanism}[https://ruby-doc.org/core/Numeric.html#method-i-coerce] is supported.
    #
    #   10 + Temperature[20, :celsius]
    #   # => 30 °C
    #
    # :call-seq:
    #   +(temperature)
    #   +(numeric)
    #
    def +(other)
      assert_numeric_or_temperature!(other)

      degrees, scale =
        case other
        when Numeric
          [self.degrees + other, self.scale]
        when Temperature
          [self.to_scale(other.scale).degrees + other.degrees, other.scale]
        end

      Temperature.new(degrees, scale)
    end

    ##
    # Performs subtraction. Returns a new Temperature.
    #
    #   Temperature[20, :celsius] - Temperature[10, :celsius]
    #   # => 10 °C
    #
    # If the second temperature has a different scale, the first temperature is automatically converted to
    # that scale before <tt>degrees</tt> subtraction.
    #
    #   Temperature[283.15, :kelvin] + Temperature[10, :celsius]
    #   # => 10 °C
    #
    # Returned temperature will have the same scale as the second temperature.
    #
    # It is possible to subtract numerics.
    #
    #   Temperature[20, :celsius] - 10
    #   # => 10 °C
    #
    # In such cases, returned temperature will have the same scale as the first temperature.
    #
    # Also {Ruby coersion mechanism}[https://ruby-doc.org/core/Numeric.html#method-i-coerce] is supported.
    #
    #   10 - Temperature[20, :celsius]
    #   # => -10 °C
    #
    # :call-seq:
    #   -(temperature)
    #   -(numeric)
    #
    def -(other)
      self + -other
    end

    ##
    # Returns a new Temperature with negated <tt>degrees</tt>.
    #
    #   -Temperature[20, :celsius]
    #   # => -20 °C
    #
    def -@
      Temperature.new(-self.degrees, self.scale)
    end

    # Is used by {+}[rdoc-ref:Temperature#+] and {-}[rdoc-ref:Temperature#-]
    # for {Ruby coersion mechanism}[https://ruby-doc.org/core/Numeric.html#method-i-coerce].
    def coerce(numeric) #:nodoc:
      assert_numeric!(numeric)

      [Temperature.new(numeric, self.scale), self]
    end

    # Returns a string containing a human-readable representation of temperature.
    def inspect #:nodoc:
      rounded_degrees = round_degrees(degrees)

      printable_degrees = degrees_without_decimal?(rounded_degrees) ? rounded_degrees.to_i : rounded_degrees

      scale_symbol =
        case self.scale
        when CELSIUS
          '°C'
        when FAHRENHEIT
          '°F'
        when KELVIN
          'K'
        when RANKINE
          '°R'
        end

      "#{printable_degrees} #{scale_symbol}"
    end
  end
  # rubocop:enable Metrics/ClassLength
end
