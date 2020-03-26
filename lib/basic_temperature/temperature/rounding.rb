# frozen_string_literal: true

module BasicTemperature
  class Temperature
    module Rounding
      private

      def round_degrees(degrees)
        degrees.round(2)
      end
    end
  end
end
