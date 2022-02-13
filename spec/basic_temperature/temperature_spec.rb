require "basic_temperature/alias"

RSpec.describe Temperature do
  it "includes Comparable module" do
    expect(Temperature.ancestors).to include(Comparable)
  end

  describe ".new" do
    context "when only positional arguments are passed" do
      it "creates an instance of temperature" do
        temperature = Temperature.new(0, "celsius")

        expect(temperature).to be_instance_of(Temperature)
      end

      it "casts degrees to float" do
        temperature = Temperature.new("0", :celsius)

        expect(temperature.degrees).to eq(0.0)
      end

      it "casts scale to string" do
        temperature = Temperature.new(0, :celsius)

        expect(temperature.scale).to eq("celsius")
      end

      context "and degrees is NOT valid (can not be casted to float)" do
        it "raises Errors::InvalidDegrees" do
          expect { Temperature.new("abc", "celsius") }
            .to raise_error(Temperature::Errors::InvalidDegrees)
            .with_message("degree is NOT a numeric value.")
        end
      end

      context "and scale is NOT valid (can not be casted to 'celsius', 'fahrenheit', 'kelvin', 'rankine')" do
        it "raises Errors::InvalidScale" do
          message =
            "scale has invalid value, " \
            "valid values are 'celsius', 'fahrenheit', 'kelvin', 'rankine'."

          expect { Temperature.new(0, "abc") }
            .to raise_error(Temperature::Errors::InvalidScale)
            .with_message(message)
        end
      end
    end

    context "when only keyword arguments are passed" do
      it "creates an instance of Temperature" do
        temperature = Temperature.new(degrees: 0, scale: "celsius")

        expect(temperature).to be_instance_of(Temperature)
      end

      it "casts degrees to float" do
        temperature = Temperature.new("0", :celsius)

        expect(temperature.degrees).to eq(0.0)
      end

      it "casts scale to string" do
        temperature = Temperature.new(degrees: 0, scale: :celsius)

        expect(temperature).to be_instance_of(Temperature)
      end

      context "and degrees is NOT valid (can not be casted to float)" do
        it "raises Errors::InvalidDegrees" do
          expect { Temperature.new(degrees: "abc", scale: "celsius") }
            .to raise_error(Temperature::Errors::InvalidDegrees)
            .with_message("degree is NOT a numeric value.")
        end
      end

      context "and scale is NOT valid (can not be casted to 'celsius', 'fahrenheit', 'kelvin', 'rankine')" do
        it "raises Errors::InvalidScale" do
          message =
            "scale has invalid value, " \
            "valid values are 'celsius', 'fahrenheit', 'kelvin', 'rankine'."

          expect { Temperature.new(degrees: 0, scale: "abc") }
            .to raise_error(Temperature::Errors::InvalidScale)
            .with_message(message)
        end
      end
    end

    context "when positional and keyword arguments are passed together" do
      it "raises Errors::InitializationArguments" do
        message =
          "Positional and keyword arguments are mixed or " \
          "neither positional nor keyword arguments are passed."

        expect { Temperature.new(0, "celsius", degrees: 0, scale: "celsius") }
          .to raise_error(Temperature::Errors::InitializationArguments)
          .with_message(message)
      end
    end

    context "when nor positional neither keyword arguments are passed" do
      it "raises Errors::InitializationArguments" do
        message =
          "Positional and keyword arguments are mixed or " \
          "neither positional nor keyword arguments are passed."

        expect { Temperature.new }
          .to raise_error(Temperature::Errors::InitializationArguments)
          .with_message(message)
      end
    end
  end

  describe ".[]" do
    it "acts as an alias of .new" do
      # TODO shared examples for .new and .[]
      expect(Temperature).to receive(:new)

      Temperature[0, "celsius"]
    end
  end

  describe "#to_celsius" do
    context "when temperature scale is celsius" do
      it "returns temperature in celsius" do
        temperature = Temperature.new(0, "celsius")

        expect(temperature.to_celsius.degrees).to eq(0)
        expect(temperature.to_celsius.scale).to eq("celsius")
      end

      it "memoizes temperature in celsius" do
        temperature = Temperature.new(0, "celsius")

        expect(temperature.to_celsius.object_id).to eq(temperature.to_celsius.object_id)
      end

      it "returns original temperature object" do
        temperature = Temperature.new(0, "celsius")

        expect(temperature.to_celsius.object_id).to eq(temperature.object_id)
      end
    end

    context "when temperature scale is fahrenheit" do
      it "returns temperature in celsius" do
        temperature = Temperature.new(68, "fahrenheit")

        expect(temperature.to_celsius.degrees).to be_within(0.01).of(20)
        expect(temperature.to_celsius.scale).to eq("celsius")
      end

      it "memoizes temperature in celsius" do
        temperature = Temperature.new(68, "fahrenheit")

        expect(temperature.to_celsius.object_id).to eq(temperature.to_celsius.object_id)
      end
    end

    context "when temperatute scale is kelvin" do
      it "returns temperature in celsius" do
        temperature = Temperature.new(300, "kelvin")

        expect(temperature.to_celsius.degrees).to be_within(0.01).of(26.85)
        expect(temperature.to_celsius.scale).to eq("celsius")
      end

      it "memoizes temperature in celsius" do
        temperature = Temperature.new(300, "kelvin")

        expect(temperature.to_celsius.object_id).to eq(temperature.to_celsius.object_id)
      end
    end

    context "when temperatute scale is rankine" do
      it "returns temperature in celsius" do
        temperature = Temperature.new(300, "rankine")

        expect(temperature.to_celsius.degrees).to be_within(0.01).of(-106.48)
        expect(temperature.to_celsius.scale).to eq("celsius")
      end

      it "memoizes temperature in celsius" do
        temperature = Temperature.new(300, "rankine")

        expect(temperature.to_celsius.object_id).to eq(temperature.to_celsius.object_id)
      end
    end
  end

  describe "#to_fahrenheit" do
    context "when temperature scale is fahrenheit" do
      it "returns temperature in fahrenheit" do
        temperature = Temperature.new(0, "fahrenheit")

        expect(temperature.to_fahrenheit.degrees).to eq(0)
        expect(temperature.to_fahrenheit.scale).to eq("fahrenheit")
      end

      it "memoizes temperature in fahrenheit" do
        temperature = Temperature.new(0, "fahrenheit")

        expect(temperature.to_fahrenheit.object_id).to eq(temperature.to_fahrenheit.object_id)
      end

      it "returns original temperature object" do
        temperature = Temperature.new(0, "fahrenheit")

        expect(temperature.to_fahrenheit.object_id).to eq(temperature.object_id)
      end
    end

    context "when temperature scale is celsius" do
      it "returns temperature in fahrenheit" do
        temperature = Temperature.new(20, "celsius")

        expect(temperature.to_fahrenheit.degrees).to be_within(0.01).of(68)
        expect(temperature.to_fahrenheit.scale).to eq("fahrenheit")
      end

      it "memoizes temperature in fahrenheit" do
        temperature = Temperature.new(20, "celsius")

        expect(temperature.to_fahrenheit.object_id).to eq(temperature.to_fahrenheit.object_id)
      end
    end

    context "when temperatute scale is kelvin" do
      it "returns new temperature in fahrenheit" do
        temperature = Temperature.new(300, "kelvin")

        expect(temperature.to_fahrenheit.degrees).to be_within(0.01).of(80.33)
        expect(temperature.to_fahrenheit.scale).to eq("fahrenheit")
      end

      it "memoizes temperature in fahrenheit" do
        temperature = Temperature.new(300, "kelvin")

        expect(temperature.to_fahrenheit.object_id).to eq(temperature.to_fahrenheit.object_id)
      end
    end

    context "when temperatute scale is rankine" do
      it "returns temperature in fahrenheit" do
        temperature = Temperature.new(300, "rankine")

        expect(temperature.to_fahrenheit.degrees).to be_within(0.01).of(-159.67)
        expect(temperature.to_fahrenheit.scale).to eq("fahrenheit")
      end

      it "memoizes temperature in fahrenheit" do
        temperature = Temperature.new(300, "rankine")

        expect(temperature.to_fahrenheit.object_id).to eq(temperature.to_fahrenheit.object_id)
      end
    end
  end

  describe "#to_kelvin" do
    context "when temperature scale is kelvin" do
      it "returns temperature in kelvin" do
        temperature = Temperature.new(0, "kelvin")

        expect(temperature.to_kelvin.degrees).to eq(0)
        expect(temperature.to_kelvin.scale).to eq("kelvin")
      end

      it "memoizes temperature in kelvin" do
        temperature = Temperature.new(0, "celsius")

        expect(temperature.to_kelvin.object_id).to eq(temperature.to_kelvin.object_id)
      end

      it "returns original temperature object" do
        temperature = Temperature.new(0, "kelvin")

        expect(temperature.to_kelvin.object_id).to eq(temperature.object_id)
      end
    end

    context "when temperature scale is celsius" do
      it "returns temperature in kelvin" do
        temperature = Temperature.new(20, "celsius")

        expect(temperature.to_kelvin.degrees).to be_within(0.01).of(293.15)
        expect(temperature.to_kelvin.scale).to eq("kelvin")
      end

      it "memoizes temperature in kelvin" do
        temperature = Temperature.new(20, "celsius")

        expect(temperature.to_kelvin.object_id).to eq(temperature.to_kelvin.object_id)
      end
    end

    context "when temperatute scale is fahrenheit" do
      it "returns temperature in kelvin" do
        temperature = Temperature.new(60, "fahrenheit")

        expect(temperature.to_kelvin.degrees).to be_within(0.01).of(288.71)
        expect(temperature.to_kelvin.scale).to eq("kelvin")
      end

      it "memoizes temperature in kelvin" do
        temperature = Temperature.new(60, "fahrenheit")

        expect(temperature.to_kelvin.object_id).to eq(temperature.to_kelvin.object_id)
      end
    end

    context "when temperatute scale is rankine" do
      it "returns temperature in kelvin" do
        temperature = Temperature.new(300, "rankine")

        expect(temperature.to_kelvin.degrees).to be_within(0.01).of(166.67)
        expect(temperature.to_kelvin.scale).to eq("kelvin")
      end

      it "memoizes temperature in kelvin" do
        temperature = Temperature.new(300, "rankine")

        expect(temperature.to_kelvin.object_id).to eq(temperature.to_kelvin.object_id)
      end
    end
  end

  describe "#to_rankine" do
    context "when temperature scale is rankine" do
      it "returns temperature in rankine" do
        temperature = Temperature.new(0, "rankine")

        expect(temperature.to_rankine.degrees).to eq(0)
        expect(temperature.to_rankine.scale).to eq("rankine")
      end

      it "memoizes temperature in rankine" do
        temperature = Temperature.new(0, "rankine")

        expect(temperature.to_rankine.object_id).to eq(temperature.to_rankine.object_id)
      end

      it "returns original temperature object" do
        temperature = Temperature.new(0, "rankine")

        expect(temperature.to_rankine.object_id).to eq(temperature.object_id)
      end
    end

    context "when temperature scale is celsius" do
      it "returns temperature in rankine" do
        temperature = Temperature.new(20, "celsius")

        expect(temperature.to_rankine.degrees).to be_within(0.01).of(527.67)
        expect(temperature.to_rankine.scale).to eq("rankine")
      end

      it "memoizes temperature in rankine" do
        temperature = Temperature.new(20, "celsius")

        expect(temperature.to_rankine.object_id).to eq(temperature.to_rankine.object_id)
      end
    end

    context "when temperature scale is fahrenheit" do
      it "returns temperature in rankine" do
        temperature = Temperature.new(68, "fahrenheit")

        expect(temperature.to_rankine.degrees).to be_within(0.01).of(527.67)
        expect(temperature.to_rankine.scale).to eq("rankine")
      end

      it "memoizes temperature in rankine" do
        temperature = Temperature.new(68, "fahrenheit")

        expect(temperature.to_rankine.object_id).to eq(temperature.to_rankine.object_id)
      end
    end

    context "when temperatute scale is kelvin" do
      it "returns temperature in rankine" do
        temperature = Temperature.new(300, "kelvin")

        expect(temperature.to_rankine.degrees).to be_within(0.01).of(540)
        expect(temperature.to_rankine.scale).to eq("rankine")
      end

      it "memoizes temperature in celsius" do
        temperature = Temperature.new(300, "kelvin")

        expect(temperature.to_rankine.object_id).to eq(temperature.to_rankine.object_id)
      end
    end
  end

  describe "#to_scale" do
    it "casts scale to string" do
      temperature = Temperature.new(0, :celsius)

      expect(temperature.to_scale(:fahrenheit).scale).to eq("fahrenheit")
    end

    context "when scale is celsius" do
      it "returns temperature in celsius" do
        temperature = Temperature.new(0, "celsius")

        expect(temperature.to_scale("celsius").scale).to eq("celsius")
      end
    end

    context "when scale is fahrenheit" do
      it "returns temperature in fahrenheit" do
        temperature = Temperature.new(0, "celsius")

        expect(temperature.to_scale("fahrenheit").scale).to eq("fahrenheit")
      end
    end

    context "when scale is kelvin" do
      it "returns temperature in kelvin" do
        temperature = Temperature.new(0, "celsius")

        expect(temperature.to_scale("kelvin").scale).to eq("kelvin")
      end
    end

    context "when scale is rankine" do
      it "returns temperature in rankine" do
        temperature = Temperature.new(0, "celsius")

        expect(temperature.to_scale("rankine").scale).to eq("rankine")
      end
    end

    context "when scale is NOT valid (can not be casted to 'celsius', 'fahrenheit', 'kelvin', 'rankine')" do
      it "raises Errors::InvalidScale" do
        temperature = Temperature.new(0, "celsius")

        message =
          "scale has invalid value, " \
          "valid values are 'celsius', 'fahrenheit', 'kelvin', 'rankine'."

        expect { temperature.to_scale("abc") }
          .to raise_error(Temperature::Errors::InvalidScale)
          .with_message(message)
      end
    end
  end

  describe "#==" do
    context "when other temperature is NOT an instance of Temperature" do
      it "returns false" do
        temperature = Temperature.new(0, "celsius")

        other = nil

        expect(temperature == other).to eq(false)
      end
    end

    context "when temperatures have the same scale" do
      context "when temperatures have different degrees" do
        it "returns false" do
          temperature = Temperature.new(0, "celsius")
          other = Temperature.new(15, "celsius")

          expect(temperature == other).to eq(false)
        end
      end

      context "when temperatures have the same degrees" do
        it "returns true" do
          temperature = Temperature.new(0, "celsius")
          other = Temperature.new(0, "celsius")

          expect(temperature == other).to eq(true)
        end
      end
    end

    context "when temperatures have different scales" do
      context "when converted first temperature does NOT have the same degrees as second temperature" do
        it "returns false" do
          temperature = Temperature.new(0, "celsius")
          other = Temperature.new(0, "kelvin")

          expect(temperature == other).to eq(false)
        end
      end

      context "when converted first temperature has the same degrees as second temperature" do
        it "returns true" do
          temperature = Temperature.new(0, "celsius")
          other = Temperature.new(273.15, "kelvin")

          expect(temperature == other).to eq(true)
        end
      end
    end

    it "rounds degrees up to 2 digits after decimal dot" do
      expect(Temperature.new(0.1, "celsius") == Temperature.new(0.2, "celsius")).to eq(false)
      expect(Temperature.new(0.01, "celsius") == Temperature.new(0.02, "celsius")).to eq(false)
      expect(Temperature.new(0.001, "celsius") == Temperature.new(0.002, "celsius")).to eq(true)
    end
  end

  describe "#set_degrees" do
    it "returns a new temperature with updated degrees" do
      temperature = Temperature.new(0, "celsius")

      new_temperature = temperature.set_degrees(25)

      expect(new_temperature.degrees).to eq(25)
      expect(new_temperature.object_id).not_to eq(temperature.object_id)
    end

    it "preserves previous scale of temperature" do
      temperature = Temperature.new(0, "celsius")

      new_temperature = temperature.set_degrees(25)

      expect(new_temperature.scale).to eq(temperature.scale)
    end

    context "when degrees is NOT a numeric value" do
      it "raises Errors::InvalidDegrees" do
        temperature = Temperature.new(0, "celsius")

        expect { temperature.set_degrees("abc") }
          .to raise_error(Temperature::Errors::InvalidDegrees)
          .with_message("degree is NOT a numeric value.")
      end
    end
  end

  describe "#set_scale" do
    it "returns a new temperature with updated scale" do
      temperature = Temperature.new(0, "celsius")

      new_temperature = temperature.set_scale("kelvin")

      expect(new_temperature.scale).to eq("kelvin")
      expect(new_temperature.object_id).not_to eq(temperature.object_id)
    end

    it "converts previous degrees of temperature" do
      temperature = Temperature.new(0, "celsius")

      new_temperature = temperature.set_scale("kelvin")

      expect(new_temperature.degrees).to eq(0)
    end

    context "when scale is NOT valid (can not be casted to 'celsius', 'fahrenheit', 'kelvin', 'rankine')" do
      it "raises Errors::InvalidScale" do
        temperature = Temperature.new(0, "celsius")

        message =
          "scale has invalid value, " \
          "valid values are 'celsius', 'fahrenheit', 'kelvin', 'rankine'."

        expect { temperature.set_scale("abc") }
          .to raise_error(Temperature::Errors::InvalidScale)
          .with_message(message)
      end
    end
  end

  describe "#<=>" do
    context "when first temperature is greater than second temperature" do
      it "returns 1" do
        first_temperature = Temperature.new(21, "celsius")
        second_temperature = Temperature.new(20, "celsius")

        expect(first_temperature <=> second_temperature).to eq(1)
      end
    end

    context "when first temperature is lower than second temperature" do
      it "returns -1" do
        first_temperature = Temperature.new(20, "celsius")
        second_temperature = Temperature.new(21, "celsius")

        expect(first_temperature <=> second_temperature).to eq(-1)
      end
    end

    context "when first temperature equals second temperature" do
      it "returns 0" do
        first_temperature = Temperature.new(20, "celsius")
        second_temperature = Temperature.new(20, "celsius")

        expect(first_temperature <=> second_temperature).to eq(0)
      end
    end

    context "when second temperature is NOT a Temperature" do
      it "returns nil" do
        first_temperature = Temperature.new(20, "celsius")
        second_temperature = "abc"

        expect(first_temperature <=> second_temperature).to be_nil
      end
    end

    context "when first and second temperatures have different scales" do
      it "converts first temperature to second temperature scale" do
        first_temperature = Temperature.new(20, "celsius")
        second_temperature = Temperature.new(250, "kelvin")

        expect(first_temperature <=> second_temperature).to eq(1)
      end
    end

    it "rounds degrees up to 2 digits after decimal dot" do
      expect(Temperature.new(0.1, "celsius") == Temperature.new(0.2, "celsius")).to eq(false)
      expect(Temperature.new(0.01, "celsius") == Temperature.new(0.02, "celsius")).to eq(false)
      expect(Temperature.new(0.001, "celsius") == Temperature.new(0.002, "celsius")).to eq(true)
    end
  end

  describe "#boil_water?" do
    context "when temperature is greater than 100 °C" do
      it "returns true" do
        expect(Temperature.new(101, "celsius").boil_water?).to eq(true)
      end
    end

    context "when temperature is equal to 100 °C" do
      it "returns true" do
        expect(Temperature.new(100, "celsius").boil_water?).to eq(true)
      end
    end

    context "when tempreture is less than 100 °C" do
      it "returns false" do
        expect(Temperature.new(99, "celsius").boil_water?).to eq(false)
      end
    end

    it "converts temperature to celsius before comparison" do
      expect(Temperature.new(0, "kelvin").boil_water?).to eq(false)
    end
  end

  describe "#freeze_water?" do
    context "when temperature is greater than 0 °C" do
      it "returns false" do
        expect(Temperature.new(1, "celsius").freeze_water?).to eq(false)
      end
    end

    context "when temperature is equal to 0 °C" do
      it "returns true" do
        expect(Temperature.new(0, "celsius").freeze_water?).to eq(true)
      end
    end

    context "when tempreture is less than 0 °C" do
      it "returns true" do
        expect(Temperature.new(-1, "celsius").freeze_water?).to eq(true)
      end
    end

    it "converts temperature to celsius before comparison" do
      expect(Temperature.new(0, "kelvin").freeze_water?).to eq(true)
    end
  end

  describe "#coerce" do
    context "when other is a Numeric" do
      it(
        <<~DESCRIPTION
          returns two elements array,
          where first element is other converted to Temperature
          and has the same scale as temperature,
          second - is temperature itself
        DESCRIPTION
      ) do
        temperature = Temperature.new(0, "celsius")

        coerce = temperature.coerce(10)

        expect(coerce.first.degrees).to eq(10)
        expect(coerce.first.scale).to eq("celsius")

        expect(coerce.last).to eq(temperature)
      end
    end

    context "when other is NOT a Numeric" do
      it "raises Errors::InvalidNumeric" do
        expect { Temperature.new(0, "celsius").coerce("abc") }
          .to raise_error(Temperature::Errors::InvalidNumeric)
          .with_message("`abc` is not a Numeric.")
      end
    end
  end

  describe "#inspect" do
    context "when scale is celsius" do
      it "returns tempeture as string in special format" do
        temperature = Temperature.new(0, "celsius")

        expect(temperature.inspect).to eq("0 °C")
      end

      it "rounds degrees up to 2 digits after decimal dot" do
        expect(Temperature.new(0.1, "celsius").inspect).to eq("0.1 °C")
        expect(Temperature.new(0.01, "celsius").inspect).to eq("0.01 °C")
        expect(Temperature.new(0.001, "celsius").inspect).to eq("0 °C")
      end

      it "prints float without decimal part as integer" do
        expect(Temperature.new(0.0, "celsius").inspect).to eq("0 °C")
      end
    end

    context "when scale is fahrenheit" do
      it "returns tempeture as string in special format" do
        temperature = Temperature.new(0, "fahrenheit")

        expect(temperature.inspect).to eq("0 °F")
      end

      it "rounds degrees up to 2 digits after decimal dot" do
        expect(Temperature.new(0.1, "fahrenheit").inspect).to eq("0.1 °F")
        expect(Temperature.new(0.01, "fahrenheit").inspect).to eq("0.01 °F")
        expect(Temperature.new(0.001, "fahrenheit").inspect).to eq("0 °F")
      end

      it "prints float without decimal part as integer" do
        expect(Temperature.new(0.0, "fahrenheit").inspect).to eq("0 °F")
      end
    end

    context "when scale is kelvin" do
      it "returns tempeture as string in special format" do
        temperature = Temperature.new(0, "kelvin")

        expect(temperature.inspect).to eq("0 K")
      end

      it "rounds degrees up to 2 digits after decimal dot" do
        expect(Temperature.new(0.1, "kelvin").inspect).to eq("0.1 K")
        expect(Temperature.new(0.01, "kelvin").inspect).to eq("0.01 K")
        expect(Temperature.new(0.001, "kelvin").inspect).to eq("0 K")
      end

      it "prints float without decimal part as integer" do
        expect(Temperature.new(0.0, "kelvin").inspect).to eq("0 K")
      end
    end

    context "when scale is rankine" do
      it "returns tempeture as string in special format" do
        temperature = Temperature.new(0, "rankine")

        expect(temperature.inspect).to eq("0 °R")
      end

      it "rounds degrees up to 2 digits after decimal dot" do
        expect(Temperature.new(0.1, "rankine").inspect).to eq("0.1 °R")
        expect(Temperature.new(0.01, "rankine").inspect).to eq("0.01 °R")
        expect(Temperature.new(0.001, "rankine").inspect).to eq("0 °R")
      end

      it "prints float without decimal part as integer" do
        expect(Temperature.new(0.0, "rankine").inspect).to eq("0 °R")
      end
    end
  end
end
