# frozen_string_literal: true

module Promiles
  class Radius
    include ShallowAttributes

    attribute :result_count, Integer
    attribute :response_message, String
    attribute :response_status, Integer
    attribute :has_error, Boolean
    attribute :truck_stops, Array, of: TruckStop
  end
end