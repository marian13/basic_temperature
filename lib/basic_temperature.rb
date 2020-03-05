# frozen_string_literal: true

require 'basic_temperature/version'

# Value Object for basic temperature operations like conversions from Celsius to Fahrenhait or Kelvin etc.
# rubocop:disable Metrics/ClassLength
class BasicTemperature
  include Comparable

  class InitializationArgumentsError < StandardError; end
  class InvalidDegreesError < StandardError; end
  class InvalidScaleError < StandardError; end
  class InvalidNumericOrTemperatureError < StandardError; end

  SCALES =
    [
      CELSIUS = 'celsius',
      FAHRENHEIT = 'fahrenheit',
      KELVIN = 'kelvin',
      RANKINE = 'rankine'
    ]
    .freeze

  attr_reader :degrees, :scale

  class << self
    alias [] new
  end

  def initialize(*positional_arguments, **keyword_arguments)
    assert_either_positional_arguments_or_keyword_arguments!(positional_arguments, keyword_arguments)

    if keyword_arguments.any?
      initialize_via_keywords_arguments(keyword_arguments)
    else # positional_arguments.any?
      initialize_via_positional_arguments(positional_arguments)
    end
  end

  # rubocop:disable Naming/AccessorMethodName
  def set_degrees(degrees)
    BasicTemperature.new(degrees, scale)
  end
  # rubocop:enable Naming/AccessorMethodName

  # rubocop:disable Naming/AccessorMethodName
  def set_scale(scale)
    self.to_scale(scale)
  end
  # rubocop:enable Naming/AccessorMethodName

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

      BasicTemperature.new(degrees, CELSIUS)
    })
  end

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

      BasicTemperature.new(degrees, FAHRENHEIT)
    })
  end

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

      BasicTemperature.new(degrees, KELVIN)
    })
  end

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

      BasicTemperature.new(degrees, RANKINE)
    })
  end

  def ==(other)
    return false unless assert_temperature(other)

    if self.scale == other.scale
      equal_degrees?(self.degrees, other.degrees)
    else
      equal_degrees?(self.to_scale(other.scale).degrees, other.degrees)
    end
  end

  def +(other)
    assert_numeric_or_temperature!(other)

    degrees, scale =
      case other
      when Numeric
        [self.degrees + other, self.scale]
      when BasicTemperature
        [self.to_scale(other.scale).degrees + other.degrees, other.scale]
      end

    BasicTemperature.new(degrees, scale)
  end

  def -(other)
    self + -other
  end

  def -@
    BasicTemperature.new(-self.degrees, self.scale)
  end

  def coerce(numeric)
    assert_numeric!(numeric)

    [BasicTemperature.new(numeric, self.scale), self]
  end

  def inspect
    "#{degrees.to_i} #{scale.capitalize}"
  end

  def <=>(other)
    return unless assert_temperature(other)

    compare_degrees(self.to_scale(other.scale).degrees, other.degrees)
  end

  private

  # Initialization
  def initialize_via_positional_arguments(positional_arguments)
    degrees, scale = positional_arguments

    initialize_arguments(degrees, scale)
  end

  def initialize_via_keywords_arguments(keyword_arguments)
    degrees, scale = keyword_arguments.values_at(:degrees, :scale)

    initialize_arguments(degrees, scale)
  end

  def initialize_arguments(degrees, scale)
    casted_scale = cast_scale(scale)

    assert_valid_degrees!(degrees)
    assert_valid_scale!(casted_scale)

    @degrees = degrees
    @scale = casted_scale
  end

  # Casting
  def cast_scale(scale)
    scale.to_s
  end

  # Assertions
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
    return if numeric_or_temperature.is_a?(Numeric) || numeric_or_temperature.instance_of?(BasicTemperature)

    raise_invalid_numeric_or_temperature_error(numeric_or_temperature)
  end

  def assert_numeric!(numeric)
    raise_invalid_numeric unless numeric.is_a?(Numeric)
  end

  def assert_temperature(temperature)
    temperature.instance_of?(BasicTemperature)
  end

  # Raising errors
  def raise_initialization_arguments_error
    message =
      'Positional and keyword arguments are mixed or ' \
      'neither positional nor keyword arguments are passed.'

    raise InitializationArgumentsError, message
  end

  def raise_invalid_degrees_error
    raise InvalidDegreesError, 'degree is NOT a numeric value.'
  end

  def raise_invalid_scale_error
    message =
      'scale has invalid value, ' \
      "valid values are #{SCALES.map { |scale| "'#{scale}'" }.join(', ')}."

    raise InvalidScaleError, message
  end

  def raise_invalid_numeric_or_temperature_error(numeric_or_temperature)
    raise InvalidNumericOrTemperatureError, "`#{numeric_or_temperature}` is neither Numeric nor Temperature."
  end

  # Rounding
  def equal_degrees?(first_degrees, second_degrees)
    round_degrees(first_degrees) == round_degrees(second_degrees)
  end

  def round_degrees(degrees)
    degrees.round(2)
  end

  def compare_degrees(first_degrees, second_degrees)
    round_degrees(first_degrees) <=> round_degrees(second_degrees)
  end

  # Memoization
  def memoized(key)
    name = convert_to_variable_name(key)

    return instance_variable_get(name) if instance_variable_defined?(name)
  end

  def memoize(key, proc)
    name = convert_to_variable_name(key)
    value = proc.call

    instance_variable_set(name, value)
  end

  def convert_to_variable_name(key)
    "@#{key}"
  end
end
# rubocop:enable Metrics/ClassLength
