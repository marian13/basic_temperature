require 'basic_temperature/version'

class BasicTemperature
  class InitializationArgumentsError < StandardError; end
  class InvalidDegreesError < StandardError; end
  class InvalidScaleError < StandardError; end
  class InvalidAddendError < StandardError; end
  class CoersionError < StandardError; end

  SCALES =
    [
      CELCIUS = 'celcius',
      FAHRENHEIT = 'fahrenheit',
      KELVIN = 'kelvin'
    ]
    .map(&:freeze)
    .freeze

  attr_reader :degrees, :scale

  def initialize(*positional_arguments, **keyword_arguments)
    raise_initialization_arguments_error if positional_arguments.any? && keyword_arguments.any?
    raise_initialization_arguments_error if positional_arguments.none? && keyword_arguments.none?

    if keyword_arguments.any?
      initialize_via_keywords_arguments(keyword_arguments)
    elsif positional_arguments.any?
      initialize_via_positional_arguments(positional_arguments)
    end
  end

  def set_degrees(degrees)
    BasicTemperature.new(degrees, scale)
  end

  def set_scale(scale)
    self.to_scale(scale)
  end

  def to_scale(scale)
    case cast_scale(scale)
    when CELCIUS
      to_celsius
    when FAHRENHEIT
      to_fahrenheit
    when KELVIN
      to_kelvin
    else
      raise_invalid_scale_error
    end
  end

  def to_celsius
    return @to_celsius unless @to_celsius.nil?

    return @to_celsius = self if self.scale == CELCIUS

    degrees =
      case self.scale
      when FAHRENHEIT
        (self.degrees - 32) * (5 / 9r)
      when KELVIN
        self.degrees - 273.15
      end

    @to_celsius = BasicTemperature.new(degrees, CELCIUS)
  end

  def to_fahrenheit
    return @to_fahrenheit unless @to_fahrenheit.nil?

    return @to_fahrenheit = self if self.scale == FAHRENHEIT

    degrees =
      case self.scale
      when CELCIUS
        self.degrees * (9 / 5r) + 32
      when KELVIN
        self.degrees * (9 / 5r) - 459.67
      end

    @to_fahrenheit = BasicTemperature.new(degrees, FAHRENHEIT)
  end

  def to_kelvin
    return @to_kelvin unless @to_kelvin.nil?

    return @to_kelvin = self if self.scale == KELVIN

    degrees =
      case self.scale
      when CELCIUS
        self.degrees + 273.15
      when FAHRENHEIT
        (self.degrees + 459.67) * (5 / 9r)
      end

    @to_kelvin = BasicTemperature.new(degrees, KELVIN)
  end

  def ==(other_temperature)
    return false unless other_temperature.instance_of?(BasicTemperature)

    self.degrees == other_temperature.degrees && self.scale == other_temperature.scale
  end

  def +(addend)
    degrees, scale =
      case addend
      when Numeric
        [self.degrees + addend, self.scale]
      when BasicTemperature
        [self.to_scale(addend.scale).degrees + addend.degrees, addend.scale]
      else
        raise_invalid_addend_error(addend)
      end

    BasicTemperature.new(degrees, scale)
  end

  def -(subtrahend)
    self + (-subtrahend)
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
    casted_scale = cast_scale(scale)

    assert_valid_degrees!(degrees)
    assert_valid_scale!(casted_scale)

    @degrees = degrees
    @scale = casted_scale
  end

  def cast_scale(scale)
    scale.to_s
  end

  def assert_valid_degrees!(degrees)
    raise_invalid_degrees_error unless degrees.is_a?(Numeric)
  end

  def assert_valid_scale!(scale)
    raise_invalid_scale_error unless SCALES.include?(scale)
  end

  def assert_numeric_or_temperature!(numeric_or_temperature)
    if numeric_or_temperature.is_a?(Numeric) || numeric_or_temperature.instance_of?(BasicTemperature)
      return
    end

    raise_coersion_error(numeric_or_temperature)
  end

  def assert_numeric!(numeric)
    raise_invalid_numeric unless numeric.is_a?(Numeric)
  end

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
      "valid values are #{SCALES.map { |scale| "'#{scale}'"}.join(', ')}."

    raise InvalidScaleError, message
  end

  def raise_invalid_addend_error(addend)
    raise InvalidAddendError, "`#{addend}` is neither Numeric nor Temperature."
  end

  def raise_coersion_error(object)
    raise CoersionError, "#{object} is neither Numeric nor Temperature."
  end
end
