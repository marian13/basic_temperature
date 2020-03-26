# frozen_string_literal: true

module BasicTemperature
  class Temperature
    module Casting
      private

      def cast_degrees(degrees)
        Float(degrees)
      rescue ArgumentError
        nil
      end

      def cast_scale(scale)
        scale.to_s
      end
    end
  end
end
