require "basic_temperature/alias"

RSpec.describe Temperature do
  it "includes Comparable module" do
    expect(described_class.ancestors).to include(Comparable)
  end

  describe ".new" do
    context "when only positional arguments are passed" do
      it "creates an instance of temperature" do
        temperature = described_class.new(0, "celsius")

        expect(temperature).to be_instance_of(described_class)
      end

      it "casts degrees to float" do
        temperature = described_class.new("0", :celsius)

        expect(temperature.degrees).to eq(0.0)
      end

      it "casts scale to string" do
        temperature = described_class.new(0, :celsius)

        expect(temperature.scale).to eq("celsius")
      end

      context "when degrees is NOT valid (can not be casted to float)" do
        it "raises Errors::InvalidDegrees" do
          expect { described_class.new("abc", "celsius") }
            .to raise_error(Temperature::Errors::InvalidDegrees)
            .with_message("degree is NOT a numeric value.")
        end
      end

      context "when scale is NOT valid (can not be casted to 'celsius', 'fahrenheit', 'kelvin', 'rankine')" do
        let(:message) { "scale has invalid value, valid values are 'celsius', 'fahrenheit', 'kelvin', 'rankine'." }

        it "raises Errors::InvalidScale" do
          expect { described_class.new(0, "abc") }
            .to raise_error(Temperature::Errors::InvalidScale)
            .with_message(message)
        end
      end
    end

    context "when only keyword arguments are passed" do
      it "creates an instance of Temperature" do
        temperature = described_class.new(degrees: 0, scale: "celsius")

        expect(temperature).to be_instance_of(described_class)
      end

      it "casts degrees to float" do
        temperature = described_class.new("0", :celsius)

        expect(temperature.degrees).to eq(0.0)
      end

      it "casts scale to string" do
        temperature = described_class.new(degrees: 0, scale: :celsius)

        expect(temperature).to be_instance_of(described_class)
      end

      context "when degrees is NOT valid (can not be casted to float)" do
        it "raises Errors::InvalidDegrees" do
          expect { described_class.new(degrees: "abc", scale: "celsius") }
            .to raise_error(Temperature::Errors::InvalidDegrees)
            .with_message("degree is NOT a numeric value.")
        end
      end

      context "when scale is NOT valid (can not be casted to 'celsius', 'fahrenheit', 'kelvin', 'rankine')" do
        let(:message) { "scale has invalid value, valid values are 'celsius', 'fahrenheit', 'kelvin', 'rankine'." }

        it "raises Errors::InvalidScale" do
          expect { described_class.new(degrees: 0, scale: "abc") }
            .to raise_error(Temperature::Errors::InvalidScale)
            .with_message(message)
        end
      end
    end

    context "when positional and keyword arguments are passed together" do
      let(:message) { "Positional and keyword arguments are mixed or neither positional nor keyword arguments are passed." }

      it "raises Errors::InitializationArguments" do
        expect { described_class.new(0, "celsius", degrees: 0, scale: "celsius") }
          .to raise_error(Temperature::Errors::InitializationArguments)
          .with_message(message)
      end
    end

    context "when nor positional neither keyword arguments are passed" do
      let(:message) { "Positional and keyword arguments are mixed or neither positional nor keyword arguments are passed." }

      it "raises Errors::InitializationArguments" do
        expect { described_class.new }
          .to raise_error(Temperature::Errors::InitializationArguments)
          .with_message(message)
      end
    end
  end

  describe ".[]" do
    it "acts as an alias of .new" do
      # TODO shared examples for .new and .[]
      expect(described_class).to receive(:new)

      described_class[0, "celsius"]
    end
  end

  describe "#to_celsius" do
    context "when temperature scale is celsius" do
      let(:temperature) { described_class.new(0, "celsius") }

      it "returns temperature in celsius" do
        expect(temperature.to_celsius.degrees).to eq(0)
        expect(temperature.to_celsius.scale).to eq("celsius")
      end

      it "memoizes temperature in celsius" do
        expect(temperature.to_celsius.object_id).to eq(temperature.to_celsius.object_id)
      end

      it "returns original temperature object" do
        expect(temperature.to_celsius.object_id).to eq(temperature.object_id)
      end
    end

    context "when temperature scale is fahrenheit" do
      let(:temperature) { described_class.new(68, "fahrenheit") }

      it "returns temperature in celsius" do
        expect(temperature.to_celsius.scale).to eq("celsius")
      end

      it "returns temperature with converted degrees" do
        expect(temperature.to_celsius.degrees).to be_within(0.01).of(20)
      end

      it "memoizes temperature in celsius" do
        expect(temperature.to_celsius.object_id).to eq(temperature.to_celsius.object_id)
      end
    end

    context "when temperatute scale is kelvin" do
      let(:temperature) { described_class.new(300, "kelvin") }

      it "returns temperature in celsius" do
        expect(temperature.to_celsius.scale).to eq("celsius")
      end

      it "returns temperature with converted degrees" do
        expect(temperature.to_celsius.degrees).to be_within(0.01).of(26.85)
      end

      it "memoizes temperature in celsius" do
        expect(temperature.to_celsius.object_id).to eq(temperature.to_celsius.object_id)
      end
    end

    context "when temperatute scale is rankine" do
      let(:temperature) { described_class.new(300, "rankine") }

      it "returns temperature in celsius" do
        expect(temperature.to_celsius.scale).to eq("celsius")
      end

      it "returns temperature with converted degrees" do
        expect(temperature.to_celsius.degrees).to be_within(0.01).of(-106.48)
      end

      it "memoizes temperature in celsius" do
        expect(temperature.to_celsius.object_id).to eq(temperature.to_celsius.object_id)
      end
    end
  end

  describe "#to_fahrenheit" do
    context "when temperature scale is fahrenheit" do
      let(:temperature) { described_class.new(0, "fahrenheit") }

      it "returns temperature in fahrenheit" do
        expect(temperature.to_fahrenheit.degrees).to eq(0)
        expect(temperature.to_fahrenheit.scale).to eq("fahrenheit")
      end

      it "memoizes temperature in fahrenheit" do
        expect(temperature.to_fahrenheit.object_id).to eq(temperature.to_fahrenheit.object_id)
      end

      it "returns original temperature object" do
        expect(temperature.to_fahrenheit.object_id).to eq(temperature.object_id)
      end
    end

    context "when temperature scale is celsius" do
      let(:temperature) { described_class.new(20, "celsius") }

      it "returns temperature in fahrenheit" do
        expect(temperature.to_fahrenheit.scale).to eq("fahrenheit")
      end

      it "returns temperature with converted degrees" do
        expect(temperature.to_fahrenheit.degrees).to be_within(0.01).of(68)
      end

      it "memoizes temperature in fahrenheit" do
        expect(temperature.to_fahrenheit.object_id).to eq(temperature.to_fahrenheit.object_id)
      end
    end

    context "when temperatute scale is kelvin" do
      let(:temperature) { described_class.new(300, "kelvin") }

      it "returns new temperature in fahrenheit" do
        expect(temperature.to_fahrenheit.scale).to eq("fahrenheit")
      end

      it "returns temperature with converted degrees" do
        expect(temperature.to_fahrenheit.degrees).to be_within(0.01).of(80.33)
      end

      it "memoizes temperature in fahrenheit" do
        expect(temperature.to_fahrenheit.object_id).to eq(temperature.to_fahrenheit.object_id)
      end
    end

    context "when temperatute scale is rankine" do
      let(:temperature) { described_class.new(300, "rankine") }

      it "returns temperature in fahrenheit" do
        expect(temperature.to_fahrenheit.scale).to eq("fahrenheit")
      end

      it "returns temperature with converted degrees" do
        expect(temperature.to_fahrenheit.degrees).to be_within(0.01).of(-159.67)
      end

      it "memoizes temperature in fahrenheit" do
        expect(temperature.to_fahrenheit.object_id).to eq(temperature.to_fahrenheit.object_id)
      end
    end
  end

  describe "#to_kelvin" do
    context "when temperature scale is kelvin" do
      let(:temperature) { described_class.new(0, "kelvin") }

      it "returns temperature in kelvin" do
        expect(temperature.to_kelvin.degrees).to eq(0)
        expect(temperature.to_kelvin.scale).to eq("kelvin")
      end

      it "memoizes temperature in kelvin" do
        expect(temperature.to_kelvin.object_id).to eq(temperature.to_kelvin.object_id)
      end

      it "returns original temperature object" do
        expect(temperature.to_kelvin.object_id).to eq(temperature.object_id)
      end
    end

    context "when temperature scale is celsius" do
      let(:temperature) { described_class.new(20, "celsius") }

      it "returns temperature in kelvin" do
        expect(temperature.to_kelvin.degrees).to be_within(0.01).of(293.15)
        expect(temperature.to_kelvin.scale).to eq("kelvin")
      end

      it "memoizes temperature in kelvin" do
        expect(temperature.to_kelvin.object_id).to eq(temperature.to_kelvin.object_id)
      end
    end

    context "when temperatute scale is fahrenheit" do
      let(:temperature) { described_class.new(60, "fahrenheit") }

      it "returns temperature in kelvin" do
        expect(temperature.to_kelvin.scale).to eq("kelvin")
      end

      it "returns temperature with converted degrees" do
        expect(temperature.to_kelvin.degrees).to be_within(0.01).of(288.71)
      end

      it "memoizes temperature in kelvin" do
        expect(temperature.to_kelvin.object_id).to eq(temperature.to_kelvin.object_id)
      end
    end

    context "when temperatute scale is rankine" do
      let(:temperature) { described_class.new(300, "rankine") }

      it "returns temperature in kelvin" do
        expect(temperature.to_kelvin.scale).to eq("kelvin")
      end

      it "returns temperature with converted degrees" do
        expect(temperature.to_kelvin.degrees).to be_within(0.01).of(166.67)
      end

      it "memoizes temperature in kelvin" do
        expect(temperature.to_kelvin.object_id).to eq(temperature.to_kelvin.object_id)
      end
    end
  end

  describe "#to_rankine" do
    context "when temperature scale is rankine" do
      let(:temperature) { described_class.new(0, "rankine") }

      it "returns temperature in rankine" do
        expect(temperature.to_rankine.degrees).to eq(0)
        expect(temperature.to_rankine.scale).to eq("rankine")
      end

      it "memoizes temperature in rankine" do
        expect(temperature.to_rankine.object_id).to eq(temperature.to_rankine.object_id)
      end

      it "returns original temperature object" do
        expect(temperature.to_rankine.object_id).to eq(temperature.object_id)
      end
    end

    context "when temperature scale is celsius" do
      let(:temperature) { described_class.new(20, "celsius") }

      it "returns temperature in rankine" do
        expect(temperature.to_rankine.degrees).to be_within(0.01).of(527.67)
        expect(temperature.to_rankine.scale).to eq("rankine")
      end

      it "memoizes temperature in rankine" do
        expect(temperature.to_rankine.object_id).to eq(temperature.to_rankine.object_id)
      end
    end

    context "when temperature scale is fahrenheit" do
      let(:temperature) { described_class.new(68, "fahrenheit") }

      it "returns temperature in rankine" do
        expect(temperature.to_rankine.degrees).to be_within(0.01).of(527.67)
        expect(temperature.to_rankine.scale).to eq("rankine")
      end

      it "memoizes temperature in rankine" do
        expect(temperature.to_rankine.object_id).to eq(temperature.to_rankine.object_id)
      end
    end

    context "when temperatute scale is kelvin" do
      let(:temperature) { described_class.new(300, "kelvin") }

      it "returns temperature in rankine" do
        expect(temperature.to_rankine.scale).to eq("rankine")
      end

      it "returns temperature with converted degrees" do
        expect(temperature.to_rankine.degrees).to be_within(0.01).of(540)
      end

      it "memoizes temperature in celsius" do
        expect(temperature.to_rankine.object_id).to eq(temperature.to_rankine.object_id)
      end
    end
  end

  describe "#to_scale" do
    let(:temperature) { described_class.new(0, "celsius") }

    it "casts scale to string" do
      expect(temperature.to_scale(:fahrenheit).scale).to eq("fahrenheit")
    end

    context "when scale is celsius" do
      it "returns temperature in celsius" do
        expect(temperature.to_scale("celsius").scale).to eq("celsius")
      end
    end

    context "when scale is fahrenheit" do
      it "returns temperature in fahrenheit" do
        expect(temperature.to_scale("fahrenheit").scale).to eq("fahrenheit")
      end
    end

    context "when scale is kelvin" do
      it "returns temperature in kelvin" do
        expect(temperature.to_scale("kelvin").scale).to eq("kelvin")
      end
    end

    context "when scale is rankine" do
      it "returns temperature in rankine" do
        expect(temperature.to_scale("rankine").scale).to eq("rankine")
      end
    end

    context "when scale is NOT valid (can not be casted to 'celsius', 'fahrenheit', 'kelvin', 'rankine')" do
      let(:message) { "scale has invalid value, valid values are 'celsius', 'fahrenheit', 'kelvin', 'rankine'." }

      it "raises Errors::InvalidScale" do
        expect { temperature.to_scale("abc") }
          .to raise_error(Temperature::Errors::InvalidScale)
          .with_message(message)
      end
    end
  end

  describe "#==" do
    context "when other temperature is NOT an instance of Temperature" do
      let(:temperature) { described_class.new(0, "celsius") }
      let(:other) { nil }

      it "returns false" do
        expect(temperature == other).to eq(false)
      end
    end

    context "when temperatures have the same scale" do
      context "when temperatures have different degrees" do
        let(:temperature) { described_class.new(0, "celsius") }
        let(:other) { described_class.new(15, "celsius") }

        it "returns false" do
          expect(temperature == other).to eq(false)
        end
      end

      context "when temperatures have the same degrees" do
        let(:temperature) { described_class.new(0, "celsius") }
        let(:other) { described_class.new(0, "celsius") }

        it "returns true" do
          expect(temperature == other).to eq(true)
        end
      end
    end

    context "when temperatures have different scales" do
      context "when converted first temperature does NOT have the same degrees as second temperature" do
        let(:temperature) { described_class.new(0, "celsius") }
        let(:other) { described_class.new(0, "kelvin") }

        it "returns false" do
          expect(temperature == other).to eq(false)
        end
      end

      context "when converted first temperature has the same degrees as second temperature" do
        let(:temperature) { described_class.new(0, "celsius") }
        let(:other) { described_class.new(273.15, "kelvin") }

        it "returns true" do
          expect(temperature == other).to eq(true)
        end
      end
    end

    it "does NOT round degrees with 1 digit after decimal dot" do
      expect(described_class.new(0.1, "celsius") == described_class.new(0.2, "celsius")).to eq(false)
    end

    it "does NOT round degrees with 2 digits after decimal dot" do
      expect(described_class.new(0.01, "celsius") == described_class.new(0.02, "celsius")).to eq(false)
    end

    it "rounds degrees with 2+ digits after decimal dot" do
      expect(described_class.new(0.001, "celsius") == described_class.new(0.002, "celsius")).to eq(true)
    end
  end

  describe "#set_degrees" do
    let(:temperature) { described_class.new(0, "celsius") }
    let(:new_temperature) { temperature.set_degrees(25) }

    it "returns a temperature with updated degrees" do
      expect(new_temperature.degrees).to eq(25)
    end

    it "returns a new temperature" do
      expect(new_temperature.object_id).not_to eq(temperature.object_id)
    end

    it "preserves previous scale of temperature" do
      expect(new_temperature.scale).to eq(temperature.scale)
    end

    context "when degrees is NOT a numeric value" do
      let(:message) { "degree is NOT a numeric value." }

      it "raises Errors::InvalidDegrees" do
        expect { temperature.set_degrees("abc") }
          .to raise_error(Temperature::Errors::InvalidDegrees)
          .with_message(message)
      end
    end
  end

  describe "#set_scale" do
    let(:temperature) { described_class.new(0, "celsius") }
    let(:new_temperature) { temperature.set_scale("kelvin") }

    it "returns a temperature with updated scale" do
      expect(new_temperature.scale).to eq("kelvin")
    end

    it "returns a new temperature" do
      expect(new_temperature.object_id).not_to eq(temperature.object_id)
    end

    it "converts previous degrees of temperature" do
      expect(new_temperature.degrees).to eq(0)
    end

    context "when scale is NOT valid (can not be casted to 'celsius', 'fahrenheit', 'kelvin', 'rankine')" do
      let(:message) { "scale has invalid value, valid values are 'celsius', 'fahrenheit', 'kelvin', 'rankine'." }

      it "raises Errors::InvalidScale" do
        expect { temperature.set_scale("abc") }
          .to raise_error(Temperature::Errors::InvalidScale)
          .with_message(message)
      end
    end
  end

  describe "#<=>" do
    context "when first temperature is greater than second temperature" do
      let(:first_temperature) { described_class.new(21, "celsius") }
      let(:second_temperature) { described_class.new(20, "celsius") }

      it "returns 1" do
        expect(first_temperature <=> second_temperature).to eq(1)
      end
    end

    context "when first temperature is lower than second temperature" do
      let(:first_temperature) { described_class.new(20, "celsius") }
      let(:second_temperature) { described_class.new(21, "celsius") }

      it "returns -1" do
        expect(first_temperature <=> second_temperature).to eq(-1)
      end
    end

    context "when first temperature equals second temperature" do
      let(:first_temperature) { described_class.new(20, "celsius") }
      let(:second_temperature) { described_class.new(20, "celsius") }

      it "returns 0" do
        expect(first_temperature <=> second_temperature).to eq(0)
      end
    end

    context "when second temperature is NOT a Temperature" do
      let(:first_temperature) { described_class.new(20, "celsius") }
      let(:second_temperature) { "abc" }

      it "returns nil" do
        expect(first_temperature <=> second_temperature).to be_nil
      end
    end

    context "when first and second temperatures have different scales" do
      let(:first_temperature) { described_class.new(20, "celsius") }
      let(:second_temperature) { described_class.new(250, "kelvin") }

      it "converts first temperature to second temperature scale" do
        expect(first_temperature <=> second_temperature).to eq(1)
      end
    end

    it "does NOT round degrees with 1 digit after decimal dot" do
      expect(described_class.new(0.1, "celsius") <=> described_class.new(0.2, "celsius")).to eq(-1)
    end

    it "does NOT round degrees with 2 digits after decimal dot" do
      expect(described_class.new(0.01, "celsius") <=> described_class.new(0.02, "celsius")).to eq(-1)
    end

    it "rounds degrees with 2+ digits after decimal dot" do
      expect(described_class.new(0.001, "celsius") <=> described_class.new(0.002, "celsius")).to eq(0)
    end
  end

  describe "#boil_water?" do
    context "when temperature is greater than 100 °C" do
      it "returns true" do
        expect(described_class.new(101, "celsius").boil_water?).to eq(true)
      end
    end

    context "when temperature is equal to 100 °C" do
      it "returns true" do
        expect(described_class.new(100, "celsius").boil_water?).to eq(true)
      end
    end

    context "when tempreture is less than 100 °C" do
      it "returns false" do
        expect(described_class.new(99, "celsius").boil_water?).to eq(false)
      end
    end

    it "converts temperature to celsius before comparison" do
      expect(described_class.new(0, "kelvin").boil_water?).to eq(false)
    end
  end

  describe "#freeze_water?" do
    context "when temperature is greater than 0 °C" do
      it "returns false" do
        expect(described_class.new(1, "celsius").freeze_water?).to eq(false)
      end
    end

    context "when temperature is equal to 0 °C" do
      it "returns true" do
        expect(described_class.new(0, "celsius").freeze_water?).to eq(true)
      end
    end

    context "when tempreture is less than 0 °C" do
      it "returns true" do
        expect(described_class.new(-1, "celsius").freeze_water?).to eq(true)
      end
    end

    it "converts temperature to celsius before comparison" do
      expect(described_class.new(0, "kelvin").freeze_water?).to eq(true)
    end
  end

  describe "#coerce" do
    let(:temperature) { described_class.new(0, "celsius") }

    context "when other is a Numeric" do
      it(
        <<~DESCRIPTION
          returns two elements array,
          where first element is other converted to Temperature
          and has the same scale as temperature,
          second - is temperature itself
        DESCRIPTION
      ) do
        expect(temperature.coerce(10)).to eq([described_class.new(10, :celsius), temperature])
      end
    end

    context "when other is NOT a Numeric" do
      let(:message) { "`abc` is not a Numeric." }

      it "raises Errors::InvalidNumeric" do
        expect { temperature.coerce("abc") }
          .to raise_error(Temperature::Errors::InvalidNumeric)
          .with_message(message)
      end
    end
  end

  describe "#inspect" do
    context "when scale is celsius" do
      it "returns tempeture as string in special format" do
        expect(described_class.new(0, "celsius").inspect).to eq("0 °C")
      end

      it "prints float without decimal part as integer" do
        expect(described_class.new(0.0, "celsius").inspect).to eq("0 °C")
      end

      it "prints float with decimal part as float" do
        expect(described_class.new(0.01, "celsius").inspect).to eq("0.01 °C")
      end

      it "rounds degrees up to 2 digits after decimal dot" do
        expect(described_class.new(0.001, "celsius").inspect).to eq("0 °C")
      end
    end

    context "when scale is fahrenheit" do
      it "returns tempeture as string in special format" do
        expect(described_class.new(0, "fahrenheit").inspect).to eq("0 °F")
      end

      it "prints float without decimal part as integer" do
        expect(described_class.new(0.0, "fahrenheit").inspect).to eq("0 °F")
      end

      it "prints float with decimal part as float" do
        expect(described_class.new(0.01, "fahrenheit").inspect).to eq("0.01 °F")
      end

      it "rounds degrees up to 2 digits after decimal dot" do
        expect(described_class.new(0.001, "fahrenheit").inspect).to eq("0 °F")
      end
    end

    context "when scale is kelvin" do
      it "returns tempeture as string in special format" do
        expect(described_class.new(0, "kelvin").inspect).to eq("0 K")
      end

      it "prints float without decimal part as integer" do
        expect(described_class.new(0.0, "kelvin").inspect).to eq("0 K")
      end

      it "prints float with decimal part as float" do
        expect(described_class.new(0.01, "kelvin").inspect).to eq("0.01 K")
      end

      it "rounds degrees up to 2 digits after decimal dot" do
        expect(described_class.new(0.001, "kelvin").inspect).to eq("0 K")
      end
    end

    context "when scale is rankine" do
      it "returns tempeture as string in special format" do
        expect(described_class.new(0, "rankine").inspect).to eq("0 °R")
      end

      it "prints float without decimal part as integer" do
        expect(described_class.new(0.0, "rankine").inspect).to eq("0 °R")
      end

      it "prints float with decimal part as float" do
        expect(described_class.new(0.01, "rankine").inspect).to eq("0.01 °R")
      end

      it "rounds degrees up to 2 digits after decimal dot" do
        expect(described_class.new(0.001, "rankine").inspect).to eq("0 °R")
      end
    end
  end
end
