require 'basic_temperature/temperature'

RSpec.describe Temperature do
  it 'has a version number' do
    expect(Temperature::VERSION).not_to be_nil
  end

  it 'includes Comparable module' do
    expect(Temperature.ancestors).to include(Comparable)
  end

  describe '.new' do
    context 'when only positional arguments are passed' do
      it 'creates an instance of temperature' do
        temperature = Temperature.new(0, 'celsius')

        expect(temperature).to be_instance_of(Temperature)
      end

      it 'casts scale to string' do
        temperature = Temperature.new(0, :celsius)

        expect(temperature.scale).to eq('celsius')
      end

      context 'and degrees is NOT a numeric value' do
        it 'raises InvalidDegreesError' do
          expect { Temperature.new('0', 'celsius') }
            .to raise_error(Temperature::InvalidDegreesError)
            .with_message('degree is NOT a numeric value.')
        end
      end

      context 'and scale is NOT valid (can not be casted to \'celsius\', \'fahrenheit\', \'kelvin\', \'rankine\')' do
        it 'raises InvalidScaleError' do
          message =
            'scale has invalid value, ' \
            'valid values are \'celsius\', \'fahrenheit\', \'kelvin\', \'rankine\'.'

          expect { Temperature.new(0, 'abc') }
            .to raise_error(Temperature::InvalidScaleError)
            .with_message(message)
        end
      end
    end

    context 'when only keyword arguments are passed' do
      it 'creates an instance of Temperature' do
        temperature = Temperature.new(degrees: 0, scale: 'celsius')

        expect(temperature).to be_instance_of(Temperature)
      end

      it 'casts scale to string' do
        temperature = Temperature.new(degrees: 0, scale: :celsius)

        expect(temperature).to be_instance_of(Temperature)
      end

      context 'and degrees is NOT a numeric value' do
        it 'raises InvalidDegreesError' do
          expect { Temperature.new(degrees: '0', scale: 'celsius') }
            .to raise_error(Temperature::InvalidDegreesError)
            .with_message('degree is NOT a numeric value.')
        end
      end

      context 'and scale is NOT valid (can not be casted to \'celsius\', \'fahrenheit\', \'kelvin\', \'rankine\')' do
        it 'raises InvalidScaleError' do
          message =
            'scale has invalid value, ' \
            'valid values are \'celsius\', \'fahrenheit\', \'kelvin\', \'rankine\'.'

          expect { Temperature.new(degrees: 0, scale: 'abc') }
            .to raise_error(Temperature::InvalidScaleError)
            .with_message(message)
        end
      end
    end

    context 'when positional and keyword arguments are passed together' do
      it 'raises InitializationArgumentsError' do
        message =
          'Positional and keyword arguments are mixed or ' \
          'neither positional nor keyword arguments are passed.'

        expect { Temperature.new(0, 'celsius', degrees: 0, scale: 'celsius') }
          .to raise_error(Temperature::InitializationArgumentsError)
          .with_message(message)
      end
    end

    context 'when nor positional neither keyword arguments are passed' do
      it 'raises InitializationArgumentsError' do
        message =
          'Positional and keyword arguments are mixed or ' \
          'neither positional nor keyword arguments are passed.'

        expect { Temperature.new }
          .to raise_error(Temperature::InitializationArgumentsError)
          .with_message(message)
      end
    end
  end

  describe '.[]' do
    it 'is an alias of .new' do
      Temperature.method(:[]) == Temperature.method(:new)
    end
  end

  describe '#to_celsius' do
    context 'when temperature scale is celsius' do
      it 'returns temperature in celsius' do
        temperature = Temperature.new(0, 'celsius')

        expect(temperature.to_celsius.degrees).to eq(0)
        expect(temperature.to_celsius.scale).to eq('celsius')
      end

      it 'memoizes temperature in celsius' do
        temperature = Temperature.new(0, 'celsius')

        expect(temperature.to_celsius.object_id).to eq(temperature.to_celsius.object_id)
      end

      it 'returns original temperature object' do
        temperature = Temperature.new(0, 'celsius')

        expect(temperature.to_celsius.object_id).to eq(temperature.object_id)
      end
    end

    context 'when temperature scale is fahrenheit' do
      it 'returns temperature in celsius' do
        temperature = Temperature.new(122, 'fahrenheit')

        expect(temperature.to_celsius.degrees).to eq(50)
        expect(temperature.to_celsius.scale).to eq('celsius')
      end

      it 'memoizes temperature in celsius' do
        temperature = Temperature.new(122, 'fahrenheit')

        expect(temperature.to_celsius.object_id).to eq(temperature.to_celsius.object_id)
      end
    end

    context 'when temperatute scale is kelvin' do
      it 'returns temperature in celsius' do
        temperature = Temperature.new(273.15, 'kelvin')

        expect(temperature.to_celsius.degrees).to eq(0)
        expect(temperature.to_celsius.scale).to eq('celsius')
      end

      it 'memoizes temperature in celsius' do
        temperature = Temperature.new(273.15, 'kelvin')

        expect(temperature.to_celsius.object_id).to eq(temperature.to_celsius.object_id)
      end
    end

    context 'when temperatute scale is rankine' do
      it 'returns temperature in celsius' do
        temperature = Temperature.new(300, 'rankine')

        expect(temperature.to_celsius.degrees).to be_within(0.01).of(-106.48)
        expect(temperature.to_celsius.scale).to eq('celsius')
      end

      it 'memoizes temperature in celsius' do
        temperature = Temperature.new(300, 'rankine')

        expect(temperature.to_celsius.object_id).to eq(temperature.to_celsius.object_id)
      end
    end
  end

  describe '#to_fahrenheit' do
    context 'when temperature scale is fahrenheit' do
      it 'returns temperature in fahrenheit' do
        temperature = Temperature.new(0, 'fahrenheit')

        expect(temperature.to_fahrenheit.degrees).to eq(0)
        expect(temperature.to_fahrenheit.scale).to eq('fahrenheit')
      end

      it 'memoizes temperature in fahrenheit' do
        temperature = Temperature.new(0, 'fahrenheit')

        expect(temperature.to_fahrenheit.object_id).to eq(temperature.to_fahrenheit.object_id)
      end

      it 'returns original temperature object' do
        temperature = Temperature.new(0, 'fahrenheit')

        expect(temperature.to_fahrenheit.object_id).to eq(temperature.object_id)
      end
    end

    context 'when temperature scale is celsius' do
      it 'returns temperature in fahrenheit' do
        temperature = Temperature.new(50, 'celsius')

        expect(temperature.to_fahrenheit.degrees).to eq(122)
        expect(temperature.to_fahrenheit.scale).to eq('fahrenheit')
      end

      it 'memoizes temperature in fahrenheit' do
        temperature = Temperature.new(50, 'celsius')

        expect(temperature.to_fahrenheit.object_id).to eq(temperature.to_fahrenheit.object_id)
      end
    end

    context 'when temperatute scale is kelvin' do
      it 'returns new temperature in fahrenheit' do
        temperature = Temperature.new(288.71, 'kelvin')

        expect(temperature.to_fahrenheit.degrees).to eq(60.00799999999998)
        expect(temperature.to_fahrenheit.scale).to eq('fahrenheit')
      end

      it 'memoizes temperature in fahrenheit' do
        temperature = Temperature.new(288.71, 'kelvin')

        expect(temperature.to_fahrenheit.object_id).to eq(temperature.to_fahrenheit.object_id)
      end
    end

    context 'when temperatute scale is rankine' do
      it 'returns temperature in fahrenheit' do
        temperature = Temperature.new(300, 'rankine')

        expect(temperature.to_fahrenheit.degrees).to be_within(0.01).of(-159.67)
        expect(temperature.to_fahrenheit.scale).to eq('fahrenheit')
      end

      it 'memoizes temperature in fahrenheit' do
        temperature = Temperature.new(300, 'rankine')

        expect(temperature.to_fahrenheit.object_id).to eq(temperature.to_fahrenheit.object_id)
      end
    end
  end

  describe '#to_kelvin' do
    context 'when temperature scale is kelvin' do
      it 'returns temperature in kelvin' do
        temperature = Temperature.new(0, 'kelvin')

        expect(temperature.to_kelvin.degrees).to eq(0)
        expect(temperature.to_kelvin.scale).to eq('kelvin')
      end

      it 'memoizes temperature in kelvin' do
        temperature = Temperature.new(0, 'celsius')

        expect(temperature.to_kelvin.object_id).to eq(temperature.to_kelvin.object_id)
      end

      it 'returns original temperature object' do
        temperature = Temperature.new(0, 'kelvin')

        expect(temperature.to_kelvin.object_id).to eq(temperature.object_id)
      end
    end

    context 'when temperature scale is celsius' do
      it 'returns temperature in kelvin' do
        temperature = Temperature.new(0, 'celsius')

        expect(temperature.to_kelvin.degrees).to eq(273.15)
        expect(temperature.to_kelvin.scale).to eq('kelvin')
      end

      it 'memoizes temperature in kelvin' do
        temperature = Temperature.new(0, 'celsius')

        expect(temperature.to_kelvin.object_id).to eq(temperature.to_kelvin.object_id)
      end
    end

    context 'when temperatute scale is fahrenheit' do
      it 'returns temperature in kelvin' do
        temperature = Temperature.new(60.00799999999998, 'fahrenheit')

        expect(temperature.to_kelvin.degrees).to eq(288.71000000000004)
        expect(temperature.to_kelvin.scale).to eq('kelvin')
      end

      it 'memoizes temperature in kelvin' do
        temperature = Temperature.new(60.00799999999998, 'fahrenheit')

        expect(temperature.to_kelvin.object_id).to eq(temperature.to_kelvin.object_id)
      end
    end

    context 'when temperatute scale is rankine' do
      it 'returns temperature in kelvin' do
        temperature = Temperature.new(300, 'rankine')

        expect(temperature.to_kelvin.degrees).to be_within(0.01).of(166.67)
        expect(temperature.to_kelvin.scale).to eq('kelvin')
      end

      it 'memoizes temperature in kelvin' do
        temperature = Temperature.new(300, 'rankine')

        expect(temperature.to_kelvin.object_id).to eq(temperature.to_kelvin.object_id)
      end
    end
  end

  describe '#to_rankine' do
    context 'when temperature scale is rankine' do
      it 'returns temperature in rankine' do
        temperature = Temperature.new(0, 'rankine')

        expect(temperature.to_rankine.degrees).to eq(0)
        expect(temperature.to_rankine.scale).to eq('rankine')
      end

      it 'memoizes temperature in rankine' do
        temperature = Temperature.new(0, 'rankine')

        expect(temperature.to_rankine.object_id).to eq(temperature.to_rankine.object_id)
      end

      it 'returns original temperature object' do
        temperature = Temperature.new(0, 'rankine')

        expect(temperature.to_rankine.object_id).to eq(temperature.object_id)
      end
    end

    context 'when temperature scale is celsius' do
      it 'returns temperature in rankine' do
        temperature = Temperature.new(20, 'celsius')

        expect(temperature.to_rankine.degrees).to be_within(0.01).of(527.67)
        expect(temperature.to_rankine.scale).to eq('rankine')
      end

      it 'memoizes temperature in rankine' do
        temperature = Temperature.new(20, 'celsius')

        expect(temperature.to_rankine.object_id).to eq(temperature.to_rankine.object_id)
      end
    end

    context 'when temperature scale is fahrenheit' do
      it 'returns temperature in rankine' do
        temperature = Temperature.new(68, 'fahrenheit')

        expect(temperature.to_rankine.degrees).to be_within(0.01).of(527.67)
        expect(temperature.to_rankine.scale).to eq('rankine')
      end

      it 'memoizes temperature in rankine' do
        temperature = Temperature.new(68, 'fahrenheit')

        expect(temperature.to_rankine.object_id).to eq(temperature.to_rankine.object_id)
      end
    end

    context 'when temperatute scale is kelvin' do
      it 'returns temperature in rankine' do
        temperature = Temperature.new(300, 'kelvin')

        expect(temperature.to_rankine.degrees).to be_within(0.01).of(540)
        expect(temperature.to_rankine.scale).to eq('rankine')
      end

      it 'memoizes temperature in celsius' do
        temperature = Temperature.new(300, 'kelvin')

        expect(temperature.to_rankine.object_id).to eq(temperature.to_rankine.object_id)
      end
    end
  end

  describe '#to_scale' do
    it 'casts scale to string' do
      temperature = Temperature.new(0, :celsius)

      expect(temperature.to_scale(:fahrenheit).scale).to eq('fahrenheit')
    end

    context 'when scale is celsius' do
      it 'returns temperature in celsius' do
        temperature = Temperature.new(0, 'celsius')

        expect(temperature.to_scale('celsius').scale).to eq('celsius')
      end
    end

    context 'when scale is fahrenheit' do
      it 'returns temperature in fahrenheit' do
        temperature = Temperature.new(0, 'celsius')

        expect(temperature.to_scale('fahrenheit').scale).to eq('fahrenheit')
      end
    end

    context 'when scale is kelvin' do
      it 'returns temperature in kelvin' do
        temperature = Temperature.new(0, 'celsius')

        expect(temperature.to_scale('kelvin').scale).to eq('kelvin')
      end
    end

    context 'when scale is rankine' do
      it 'returns temperature in rankine' do
        temperature = Temperature.new(0, 'celsius')

        expect(temperature.to_scale('rankine').scale).to eq('rankine')
      end
    end

    context 'when scale is NOT valid (can not be casted to \'celsius\', \'fahrenheit\', \'kelvin\', \'rankine\')' do
      it 'raises InvalidScaleError' do
        temperature = Temperature.new(0, 'celsius')

        message =
          'scale has invalid value, ' \
          'valid values are \'celsius\', \'fahrenheit\', \'kelvin\', \'rankine\'.'

        expect { temperature.to_scale('abc') }
          .to raise_error(Temperature::InvalidScaleError)
          .with_message(message)
      end
    end
  end

  describe '#==' do
    context 'when other temperature is NOT an instance of Temperature' do
      it 'returns false' do
        temperature = Temperature.new(0, 'celsius')

        other = nil

        expect(temperature == other).to eq(false)
      end
    end

    context 'when temperatures have the same scale' do
      context 'when temperatures have different degrees' do
        it 'returns false' do
          temperature = Temperature.new(0, 'celsius')
          other = Temperature.new(15, 'celsius')

          expect(temperature == other).to eq(false)
        end
      end

      context 'when temperatures have the same degrees' do
        it 'returns true' do
          temperature = Temperature.new(0, 'celsius')
          other = Temperature.new(0, 'celsius')

          expect(temperature == other).to eq(true)
        end
      end
    end

    context 'when temperatures have different scales' do
      context 'when converted first temperature does NOT have the same degrees as second temperature' do
        it 'returns false' do
          temperature = Temperature.new(0, 'celsius')
          other = Temperature.new(0, 'kelvin')

          expect(temperature == other).to eq(false)
        end
      end

      context 'when converted first temperature has the same degrees as second temperature' do
        it 'returns true' do
          temperature = Temperature.new(0, 'celsius')
          other = Temperature.new(273.15, 'kelvin')

          expect(temperature == other).to eq(true)
        end
      end
    end

    it 'rounds degrees up to 2 digits after decimal dot' do
      expect(Temperature.new(0.1, 'celsius') == Temperature.new(0.2, 'celsius')).to eq(false)
      expect(Temperature.new(0.01, 'celsius') == Temperature.new(0.02, 'celsius')).to eq(false)
      expect(Temperature.new(0.001, 'celsius') == Temperature.new(0.002, 'celsius')).to eq(true)
    end
  end

  describe '#set_degrees' do
    it 'returns a new temperature with updated degrees' do
      temperature = Temperature.new(0, 'celsius')

      new_temperature = temperature.set_degrees(25)

      expect(new_temperature.degrees).to eq(25)
      expect(new_temperature.object_id).not_to eq(temperature.object_id)
    end

    it 'preserves previous scale of temperature' do
      temperature = Temperature.new(0, 'celsius')

      new_temperature = temperature.set_degrees(25)

      expect(new_temperature.scale).to eq(temperature.scale)
    end

    context 'when degrees is NOT a numeric value' do
      it 'raises InvalidDegreesError' do
        temperature = Temperature.new(0, 'celsius')

        expect { new_temperature = temperature.set_degrees('abc') }
          .to raise_error(Temperature::InvalidDegreesError)
          .with_message('degree is NOT a numeric value.')
      end
    end
  end

  describe '#set_scale' do
    it 'returns a new temperature with updated scale' do
      temperature = Temperature.new(0, 'celsius')

      new_temperature = temperature.set_scale('kelvin')

      expect(new_temperature.scale).to eq('kelvin')
      expect(new_temperature.object_id).not_to eq(temperature.object_id)
    end

    it 'converts previous degrees of temperature' do
      temperature = Temperature.new(0, 'celsius')

      new_temperature = temperature.set_scale('kelvin')

      expect(new_temperature.degrees).to eq(273.15)
    end

    context 'when scale is NOT valid (can not be casted to \'celsius\', \'fahrenheit\', \'kelvin\', \'rankine\')' do
      it 'raises InvalidScaleError' do
        temperature = Temperature.new(0, 'celsius')

        message =
          'scale has invalid value, ' \
          'valid values are \'celsius\', \'fahrenheit\', \'kelvin\', \'rankine\'.'

        expect { new_temperature = temperature.set_scale('abc') }
          .to raise_error(Temperature::InvalidScaleError)
          .with_message(message)
      end
    end
  end

  describe '#+' do
    context 'when other is a Numeric' do
      it 'returns temperature, where degrees = self.degress + other' do
        temperature = Temperature.new(0, 'celsius')

        new_temperature = temperature + 25

        expect(new_temperature.degrees).to eq(25)
      end

      it 'supports coercion mechanism' do
        temperature = Temperature.new(0, 'celsius')

        new_temperature = 25 + temperature

        expect(new_temperature.degrees).to eq(25)
      end
    end

    context 'when other is a Temperature' do
      it 'returns temperature, where degrees = self.degress + other.degrees' do
        temperature = Temperature.new(0, 'celsius')
        other = Temperature.new(30, 'celsius')

        new_temperature = temperature + other

        expect(new_temperature.degrees).to eq(30)
      end

      context 'and other has different scale than temperature' do
        it 'returns temperature, where degrees = self.to_scale(other.scale).degress + other.degrees' do
          temperature = Temperature.new(0, 'celsius')
          other = Temperature.new(30, 'kelvin')

          new_temperature = temperature + other

          expect(new_temperature.scale).to eq(other.scale)
          expect(new_temperature.degrees).to eq(303.15)
        end
      end
    end

    context 'when other is neither Numeric nor Temperature' do
      it 'raises InvalidNumericOrTemperatureError' do
        temperature = Temperature.new(0, 'celsius')
        other = 'abc'

        expect { new_temperature = temperature + other }
          .to raise_error(Temperature::InvalidNumericOrTemperatureError)
          .with_message("`#{other}` is neither Numeric nor Temperature.")
      end
    end
  end

  describe '#+' do
    context 'when other is a Numeric' do
      it 'returns temperature, where degrees = self.degress + other' do
        temperature = Temperature.new(0, 'celsius')

        new_temperature = temperature + 25

        expect(new_temperature.degrees).to eq(25)
      end

      it 'supports coercion mechanism' do
        temperature = Temperature.new(0, 'celsius')

        new_temperature = 25 + temperature

        expect(new_temperature.degrees).to eq(25)
      end
    end

    context 'when other is a Temperature' do
      it 'returns temperature, where degrees = self.degress + other.degrees' do
        temperature = Temperature.new(0, 'celsius')
        other = Temperature.new(30, 'celsius')

        new_temperature = temperature + other

        expect(new_temperature.degrees).to eq(30)
      end

      context 'and other has different scale than temperature' do
        it 'returns temperature, where degrees = self.to_scale(other.scale).degress + other.degrees' do
          temperature = Temperature.new(0, 'celsius')
          other = Temperature.new(30, 'kelvin')

          new_temperature = temperature + other

          expect(new_temperature.scale).to eq(other.scale)
          expect(new_temperature.degrees).to eq(303.15)
        end
      end
    end

    context 'when other is neither Numeric nor Temperature' do
      it 'raises InvalidotherError' do
        temperature = Temperature.new(0, 'celsius')
        other = 'abc'

        expect { new_temperature = temperature + other }
          .to raise_error(Temperature::InvalidNumericOrTemperatureError)
          .with_message("`#{other}` is neither Numeric nor Temperature.")
      end
    end
  end

  describe '#-' do
    context 'when other is a Numeric' do
      it 'returns temperature, where degrees = self.degress - other' do
        temperature = Temperature.new(0, 'celsius')

        new_temperature = temperature - 25

        expect(new_temperature.degrees).to eq(-25)
      end

      it 'supports coercion mechanism' do
        temperature = Temperature.new(0, 'celsius')

        new_temperature = 25 - temperature

        expect(new_temperature.degrees).to eq(25)
      end
    end

    context 'when other is a Temperature' do
      it 'returns temperature, where degrees = self.degress - other.degrees' do
        temperature = Temperature.new(0, 'celsius')
        other = Temperature.new(30, 'celsius')

        new_temperature = temperature - other

        expect(new_temperature.degrees).to eq(-30)
      end

      context 'and other has different scale than temperature' do
        it 'returns temperature, where degrees = self.to_scale(other.scale).degress - other.degrees' do
          temperature = Temperature.new(0, 'celsius')
          other = Temperature.new(30, 'kelvin')

          new_temperature = temperature - other

          expect(new_temperature.scale).to eq(other.scale)
          expect(new_temperature.degrees).to eq(243.14999999999998)
        end
      end
    end

    context 'when other is neither Numeric nor Temperature' do
      it 'raises InvalidotherError' do
        temperature = Temperature.new(0, 'celsius')
        other = 'abc'

        expect { new_temperature = temperature - other }
          .to raise_error(Temperature::InvalidNumericOrTemperatureError)
          .with_message("`#{other}` is neither Numeric nor Temperature.")
      end
    end
  end

  describe '#-@' do
    it 'returns temperature, where degrees = -self.degress' do
      temperature = Temperature.new(20, 'celsius')

      new_temperature = -temperature

      expect(new_temperature.degrees).to eq(-20)
    end
  end

  describe '#<=>' do
    context 'when first temperature is greater than second temperature' do
      it 'returns 1' do
        first_temperature = Temperature.new(21, 'celsius')
        second_temperature = Temperature.new(20, 'celsius')

        expect(first_temperature <=> second_temperature).to eq(1)
      end
    end

    context 'when first temperature is lower than second temperature' do
      it 'returns -1' do
        first_temperature = Temperature.new(20, 'celsius')
        second_temperature = Temperature.new(21, 'celsius')

        expect(first_temperature <=> second_temperature).to eq(-1)
      end
    end

    context 'when first temperature equals second temperature' do
      it 'returns 0' do
        first_temperature = Temperature.new(20, 'celsius')
        second_temperature = Temperature.new(20, 'celsius')

        expect(first_temperature <=> second_temperature).to eq(0)
      end
    end

    context 'when second temperature is NOT a Temperature' do
      it 'returns nil' do
        first_temperature = Temperature.new(20, 'celsius')
        second_temperature = 'abc'

        expect(first_temperature <=> second_temperature).to be_nil
      end
    end

    context 'when first and second temperatures have different scales' do
      it 'converts first temperature to second temperature scale' do
        first_temperature = Temperature.new(20, 'celsius')
        second_temperature = Temperature.new(250, 'kelvin')

        expect(first_temperature <=> second_temperature).to eq(1)
      end
    end

    it 'rounds degrees up to 2 digits after decimal dot' do
      expect(Temperature.new(0.1, 'celsius') == Temperature.new(0.2, 'celsius')).to eq(false)
      expect(Temperature.new(0.01, 'celsius') == Temperature.new(0.02, 'celsius')).to eq(false)
      expect(Temperature.new(0.001, 'celsius') == Temperature.new(0.002, 'celsius')).to eq(true)
    end
  end

  describe '#inspect' do
    it 'returns tempeture as string in special format' do
      temperature = Temperature.new(0.1, 'celsius')

      expect(temperature.inspect).to eq("#{temperature.degrees.to_i} #{temperature.scale.capitalize}")
    end
  end
end
