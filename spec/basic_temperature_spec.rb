require 'basic_temperature'

RSpec.describe BasicTemperature do
  it 'has a version number' do
    expect(BasicTemperature::VERSION).not_to be nil
  end

  describe '.new' do
    context 'when only positional arguments are passed' do
      it 'creates an instance of temperature' do
        temperature = BasicTemperature.new(0, 'celsius')

        expect(temperature).to be_instance_of(BasicTemperature)
      end

      it 'casts scale to string' do
        temperature = BasicTemperature.new(0, :celsius)

        expect(temperature.scale).to eq('celsius')
      end

      context 'and degrees is NOT a numeric value' do
        it 'raises InvalidDegreesError' do
          expect { BasicTemperature.new('0', 'celsius') }
            .to raise_error(BasicTemperature::InvalidDegreesError)
            .with_message('degree is NOT a numeric value.')
        end
      end

      context 'and scale is NOT valid (can not be casted to \'celsius\', \'fahrenheit\', \'kelvin\')' do
        it 'raises InvalidScaleError' do
          message =
            'scale has invalid value, ' \
            'valid values are \'celsius\', \'fahrenheit\', \'kelvin\'.'

          expect { BasicTemperature.new(0, 'abc') }
            .to raise_error(BasicTemperature::InvalidScaleError)
            .with_message(message)
        end
      end
    end

    context 'when only keyword arguments are passed' do
      it 'creates an instance of Temperature' do
        temperature = BasicTemperature.new(degrees: 0, scale: 'celsius')

        expect(temperature).to be_instance_of(BasicTemperature)
      end

      it 'casts scale to string' do
        temperature = BasicTemperature.new(degrees: 0, scale: :celsius)

        expect(temperature).to be_instance_of(BasicTemperature)
      end

      context 'and degrees is NOT a numeric value' do
        it 'raises InvalidDegreesError' do
          expect { BasicTemperature.new(degrees: '0', scale: 'celsius') }
            .to raise_error(BasicTemperature::InvalidDegreesError)
            .with_message('degree is NOT a numeric value.')
        end
      end

      context 'and scale is NOT valid (can not be casted to \'celsius\', \'fahrenheit\', \'kelvin\')' do
        it 'raises InvalidScaleError' do
          message =
            'scale has invalid value, ' \
            'valid values are \'celsius\', \'fahrenheit\', \'kelvin\'.'

          expect { BasicTemperature.new(degrees: 0, scale: 'abc') }
            .to raise_error(BasicTemperature::InvalidScaleError)
            .with_message(message)
        end
      end
    end

    context 'when positional and keyword arguments are passed together' do
      it 'raises InitializationArgumentsError' do
        message =
          'Positional and keyword arguments are mixed or ' \
          'neither positional nor keyword arguments are passed.'

        expect { BasicTemperature.new(0, 'celsius', degrees: 0, scale: 'celsius') }
          .to raise_error(BasicTemperature::InitializationArgumentsError)
          .with_message(message)
      end
    end

    context 'when nor positional neither keyword arguments are passed' do
      it 'raises InitializationArgumentsError' do
        message =
          'Positional and keyword arguments are mixed or ' \
          'neither positional nor keyword arguments are passed.'

        expect { BasicTemperature.new }
          .to raise_error(BasicTemperature::InitializationArgumentsError)
          .with_message(message)
      end
    end
  end

  describe '#to_celsius' do
    context 'when temperature scale is celsius' do
      it 'returns temperature in celsius' do
        temperature = BasicTemperature.new(0, 'celsius')

        expect(temperature.to_celsius.degrees).to eq(0)
        expect(temperature.to_celsius.scale).to eq('celsius')
      end

      it 'memoizes temperature in celsius' do
        temperature = BasicTemperature.new(0, 'celsius')

        expect(temperature.to_celsius.object_id).to eq(temperature.to_celsius.object_id)
      end

      it 'returns original temperature object' do
        temperature = BasicTemperature.new(0, 'celsius')

        expect(temperature.to_celsius.object_id).to eq(temperature.object_id)
      end
    end

    context 'when temperature scale is fahrenheit' do
      it 'returns temperature in celsius' do
        temperature = BasicTemperature.new(122, 'fahrenheit')

        expect(temperature.to_celsius.degrees).to eq(50)
        expect(temperature.to_celsius.scale).to eq('celsius')
      end

      it 'memoizes temperature in celsius' do
        temperature = BasicTemperature.new(122, 'fahrenheit')

        expect(temperature.to_celsius.object_id).to eq(temperature.to_celsius.object_id)
      end
    end

    context 'when temperatute scale is kelvin' do
      it 'returns temperature in celsius' do
        temperature = BasicTemperature.new(273.15, 'kelvin')

        expect(temperature.to_celsius.degrees).to eq(0)
        expect(temperature.to_celsius.scale).to eq('celsius')
      end

      it 'memoizes temperature in celsius' do
        temperature = BasicTemperature.new(273.15, 'kelvin')

        expect(temperature.to_celsius.object_id).to eq(temperature.to_celsius.object_id)
      end
    end
  end

  describe '#to_fahrenheit' do
    context 'when temperature scale is fahrenheit' do
      it 'returns temperature in fahrenheit' do
        temperature = BasicTemperature.new(0, 'fahrenheit')

        expect(temperature.to_fahrenheit.degrees).to eq(0)
        expect(temperature.to_fahrenheit.scale).to eq('fahrenheit')
      end

      it 'memoizes temperature in fahrenheit' do
        temperature = BasicTemperature.new(0, 'fahrenheit')

        expect(temperature.to_fahrenheit.object_id).to eq(temperature.to_fahrenheit.object_id)
      end

      it 'returns original temperature object' do
        temperature = BasicTemperature.new(0, 'fahrenheit')

        expect(temperature.to_fahrenheit.object_id).to eq(temperature.object_id)
      end
    end

    context 'when temperature scale is celsius' do
      it 'returns temperature in fahrenheit' do
        temperature = BasicTemperature.new(50, 'celsius')

        expect(temperature.to_fahrenheit.degrees).to eq(122)
        expect(temperature.to_fahrenheit.scale).to eq('fahrenheit')
      end

      it 'memoizes temperature in fahrenheit' do
        temperature = BasicTemperature.new(50, 'celsius')

        expect(temperature.to_fahrenheit.object_id).to eq(temperature.to_fahrenheit.object_id)
      end
    end

    context 'when temperatute scale is kelvin' do
      it 'returns new temperature in fahrenheit' do
        temperature = BasicTemperature.new(288.71, 'kelvin')

        expect(temperature.to_fahrenheit.degrees).to eq(60.00799999999998)
        expect(temperature.to_fahrenheit.scale).to eq('fahrenheit')
      end

      it 'memoizes temperature in fahrenheit' do
        temperature = BasicTemperature.new(288.71, 'kelvin')

        expect(temperature.to_fahrenheit.object_id).to eq(temperature.to_fahrenheit.object_id)
      end
    end
  end

  describe '#to_kelvin' do
    context 'when temperature scale is kelvin' do
      it 'returns temperature in kelvin' do
        temperature = BasicTemperature.new(0, 'kelvin')

        expect(temperature.to_kelvin.degrees).to eq(0)
        expect(temperature.to_kelvin.scale).to eq('kelvin')
      end

      it 'memoizes temperature in kelvin' do
        temperature = BasicTemperature.new(0, 'celsius')

        expect(temperature.to_kelvin.object_id).to eq(temperature.to_kelvin.object_id)
      end

      it 'returns original temperature object' do
        temperature = BasicTemperature.new(0, 'kelvin')

        expect(temperature.to_kelvin.object_id).to eq(temperature.object_id)
      end
    end

    context 'when temperature scale is celsius' do
      it 'returns temperature in kelvin' do
        temperature = BasicTemperature.new(0, 'celsius')

        expect(temperature.to_kelvin.degrees).to eq(273.15)
        expect(temperature.to_kelvin.scale).to eq('kelvin')
      end

      it 'memoizes temperature in kelvin' do
        temperature = BasicTemperature.new(0, 'celsius')

        expect(temperature.to_kelvin.object_id).to eq(temperature.to_kelvin.object_id)
      end
    end

    context 'when temperatute scale is fahrenheit' do
      it 'returns temperature in kelvin' do
        temperature = BasicTemperature.new(60.00799999999998, 'fahrenheit')

        expect(temperature.to_kelvin.degrees).to eq(288.71000000000004)
        expect(temperature.to_kelvin.scale).to eq('kelvin')
      end

      it 'memoizes temperature in kelvin' do
        temperature = BasicTemperature.new(60.00799999999998, 'fahrenheit')

        expect(temperature.to_kelvin.object_id).to eq(temperature.to_kelvin.object_id)
      end
    end
  end

  describe '#to_scale' do
    it 'casts scale to string' do
      temperature = BasicTemperature.new(0, :celsius)

      expect(temperature.to_scale(:fahrenheit).scale).to eq('fahrenheit')
    end

    context 'when scale is celsius' do
      it 'returns temperature in celsius' do
        temperature = BasicTemperature.new(0, 'celsius')

        expect(temperature.to_scale('celsius').scale).to eq('celsius')
      end
    end

    context 'when scale is fahrenheit' do
      it 'returns temperature in fahrenheit' do
        temperature = BasicTemperature.new(0, 'celsius')

        expect(temperature.to_scale('fahrenheit').scale).to eq('fahrenheit')
      end
    end

    context 'when scale is kelvin' do
      it 'returns temperature in kelvin' do
        temperature = BasicTemperature.new(0, 'celsius')

        expect(temperature.to_scale('kelvin').scale).to eq('kelvin')
      end
    end

    context 'when scale is NOT valid (can not be casted to \'celsius\', \'fahrenheit\', \'kelvin\')' do
      it 'raises InvalidScaleError' do
        temperature = BasicTemperature.new(0, 'celsius')

        message =
          'scale has invalid value, ' \
          'valid values are \'celsius\', \'fahrenheit\', \'kelvin\'.'

        expect { temperature.to_scale('abc') }
          .to raise_error(BasicTemperature::InvalidScaleError)
          .with_message(message)
      end
    end
  end

  describe '#==' do
    context 'when other temperature is NOT an instance of Temperature' do
      it 'returns false' do
        temperature = BasicTemperature.new(0, 'celsius')

        other = nil

        expect(temperature == other).to eq(false)
      end
    end

    context 'when temperatures have the same scale' do
      context 'when temperatures have different degrees' do
        it 'returns false' do
          temperature = BasicTemperature.new(0, 'celsius')
          other = BasicTemperature.new(15, 'celsius')

          expect(temperature == other).to eq(false)
        end
      end

      context 'when temperatures have the same degrees' do
        it 'returns true' do
          temperature = BasicTemperature.new(0, 'celsius')
          other = BasicTemperature.new(0, 'celsius')

          expect(temperature == other).to eq(true)
        end
      end
    end

    context 'when temperatures have different scales' do
      context 'when converted first temperature does NOT have the same degrees as second temperature' do
        it 'returns false' do
          temperature = BasicTemperature.new(0, 'celsius')
          other = BasicTemperature.new(0, 'kelvin')

          expect(temperature == other).to eq(false)
        end
      end

      context 'when converted first temperature has the same degrees as second temperature' do
        it 'returns true' do
          temperature = BasicTemperature.new(0, 'celsius')
          other = BasicTemperature.new(273.15, 'kelvin')

          expect(temperature == other).to eq(true)
        end
      end
    end
  end

  describe '#set_degrees' do
    it 'returns a new temperature with updated degrees' do
      temperature = BasicTemperature.new(0, 'celsius')

      new_temperature = temperature.set_degrees(25)

      expect(new_temperature.degrees).to eq(25)
      expect(new_temperature.object_id).not_to eq(temperature.object_id)
    end

    it 'preserves previous scale of temperature' do
      temperature = BasicTemperature.new(0, 'celsius')

      new_temperature = temperature.set_degrees(25)

      expect(new_temperature.scale).to eq(temperature.scale)
    end

    context 'when degrees is NOT a numeric value' do
      it 'raises InvalidDegreesError' do
        temperature = BasicTemperature.new(0, 'celsius')

        expect { new_temperature = temperature.set_degrees('abc') }
          .to raise_error(BasicTemperature::InvalidDegreesError)
          .with_message('degree is NOT a numeric value.')
      end
    end
  end

  describe '#set_scale' do
    it 'returns a new temperature with updated scale' do
      temperature = BasicTemperature.new(0, 'celsius')

      new_temperature = temperature.set_scale('kelvin')

      expect(new_temperature.scale).to eq('kelvin')
      expect(new_temperature.object_id).not_to eq(temperature.object_id)
    end

    it 'converts previous degrees of temperature' do
      temperature = BasicTemperature.new(0, 'celsius')

      new_temperature = temperature.set_scale('kelvin')

      expect(new_temperature.degrees).to eq(273.15)
    end

    context 'when scale is NOT valid (can not be casted to \'celsius\', \'fahrenheit\', \'kelvin\')' do
      it 'raises InvalidScaleError' do
        temperature = BasicTemperature.new(0, 'celsius')

        message =
          'scale has invalid value, ' \
          'valid values are \'celsius\', \'fahrenheit\', \'kelvin\'.'

        expect { new_temperature = temperature.set_scale('abc') }
          .to raise_error(BasicTemperature::InvalidScaleError)
          .with_message(message)
      end
    end
  end

  describe '#+' do
    context 'when other is a Numeric' do
      it 'returns temperature, where degrees = self.degress + other' do
        temperature = BasicTemperature.new(0, 'celsius')

        new_temperature = temperature + 25

        expect(new_temperature.degrees).to eq(25)
      end

      it 'supports coercion mechanism' do
        temperature = BasicTemperature.new(0, 'celsius')

        new_temperature = 25 + temperature

        expect(new_temperature.degrees).to eq(25)
      end
    end

    context 'when other is a Temperature' do
      it 'returns temperature, where degrees = self.degress + other.degrees' do
        temperature = BasicTemperature.new(0, 'celsius')
        other = BasicTemperature.new(30, 'celsius')

        new_temperature = temperature + other

        expect(new_temperature.degrees).to eq(30)
      end

      context 'and other has different scale than temperature' do
        it 'returns temperature, where degrees = self.to_scale(other.scale).degress + other.degrees' do
          temperature = BasicTemperature.new(0, 'celsius')
          other = BasicTemperature.new(30, 'kelvin')

          new_temperature = temperature + other

          expect(new_temperature.scale).to eq(other.scale)
          expect(new_temperature.degrees).to eq(303.15)
        end
      end
    end

    context 'when other is neither Numeric nor Temperature' do
      it 'raises CoersionError' do
        temperature = BasicTemperature.new(0, 'celsius')
        other = 'abc'

        expect { new_temperature = temperature + other }
          .to raise_error(BasicTemperature::InvalidOtherError)
          .with_message("`#{other}` is neither Numeric nor Temperature.")
      end
    end
  end

  describe '#+' do
    context 'when other is a Numeric' do
      it 'returns temperature, where degrees = self.degress + other' do
        temperature = BasicTemperature.new(0, 'celsius')

        new_temperature = temperature + 25

        expect(new_temperature.degrees).to eq(25)
      end

      it 'supports coercion mechanism' do
        temperature = BasicTemperature.new(0, 'celsius')

        new_temperature = 25 + temperature

        expect(new_temperature.degrees).to eq(25)
      end
    end

    context 'when other is a Temperature' do
      it 'returns temperature, where degrees = self.degress + other.degrees' do
        temperature = BasicTemperature.new(0, 'celsius')
        other = BasicTemperature.new(30, 'celsius')

        new_temperature = temperature + other

        expect(new_temperature.degrees).to eq(30)
      end

      context 'and other has different scale than temperature' do
        it 'returns temperature, where degrees = self.to_scale(other.scale).degress + other.degrees' do
          temperature = BasicTemperature.new(0, 'celsius')
          other = BasicTemperature.new(30, 'kelvin')

          new_temperature = temperature + other

          expect(new_temperature.scale).to eq(other.scale)
          expect(new_temperature.degrees).to eq(303.15)
        end
      end
    end

    context 'when other is neither Numeric nor Temperature' do
      it 'raises InvalidotherError' do
        temperature = BasicTemperature.new(0, 'celsius')
        other = 'abc'

        expect { new_temperature = temperature + other }
          .to raise_error(BasicTemperature::InvalidOtherError)
          .with_message("`#{other}` is neither Numeric nor Temperature.")
      end
    end
  end

  describe '#-' do
    context 'when other is a Numeric' do
      it 'returns temperature, where degrees = self.degress - other' do
        temperature = BasicTemperature.new(0, 'celsius')

        new_temperature = temperature - 25

        expect(new_temperature.degrees).to eq(-25)
      end

      it 'supports coercion mechanism' do
        temperature = BasicTemperature.new(0, 'celsius')

        new_temperature = 25 - temperature

        expect(new_temperature.degrees).to eq(25)
      end
    end

    context 'when other is a Temperature' do
      it 'returns temperature, where degrees = self.degress - other.degrees' do
        temperature = BasicTemperature.new(0, 'celsius')
        other = BasicTemperature.new(30, 'celsius')

        new_temperature = temperature - other

        expect(new_temperature.degrees).to eq(-30)
      end

      context 'and other has different scale than temperature' do
        it 'returns temperature, where degrees = self.to_scale(other.scale).degress - other.degrees' do
          temperature = BasicTemperature.new(0, 'celsius')
          other = BasicTemperature.new(30, 'kelvin')

          new_temperature = temperature - other

          expect(new_temperature.scale).to eq(other.scale)
          expect(new_temperature.degrees).to eq(243.14999999999998)
        end
      end
    end

    context 'when other is neither Numeric nor Temperature' do
      it 'raises InvalidotherError' do
        temperature = BasicTemperature.new(0, 'celsius')
        other = 'abc'

        expect { new_temperature = temperature - other }
          .to raise_error(BasicTemperature::InvalidOtherError)
          .with_message("`#{other}` is neither Numeric nor Temperature.")
      end
    end
  end

  describe '#-@' do
    it 'returns temperature, where degrees = -self.degress' do
      temperature = BasicTemperature.new(20, 'celsius')

      new_temperature = -temperature

      expect(new_temperature.degrees).to eq(-20)
    end
  end

  describe '#<=>' do
    context 'when first temperature is greater than second temperature' do
      it 'returns 1' do
        first_temperature = BasicTemperature.new(21, 'celsius')
        second_temperature = BasicTemperature.new(20, 'celsius')

        expect(first_temperature <=> second_temperature).to eq(1)
      end
    end

    context 'when first temperature is lower than second temperature' do
      it 'returns -1' do
        first_temperature = BasicTemperature.new(20, 'celsius')
        second_temperature = BasicTemperature.new(21, 'celsius')

        expect(first_temperature <=> second_temperature).to eq(-1)
      end
    end

    context 'when first temperature equals second temperature' do
      it 'returns 0' do
        first_temperature = BasicTemperature.new(20, 'celsius')
        second_temperature = BasicTemperature.new(20, 'celsius')

        expect(first_temperature <=> second_temperature).to eq(0)
      end
    end

    context 'when second temperature is NOT a Temperature' do
      it 'returns nil' do
        first_temperature = BasicTemperature.new(20, 'celsius')
        second_temperature = 'abc'

        expect(first_temperature <=> second_temperature).to be_nil
      end
    end

    context 'when first and second temperatures have different scales' do
      it 'converts first temperature to second temperature scale' do
        first_temperature = BasicTemperature.new(20, 'celsius')
        second_temperature = BasicTemperature.new(250, 'kelvin')

        expect(first_temperature <=> second_temperature).to eq(1)
      end
    end
  end
end
