# frozen_string_literal: true

module Promiles
  class Runtrip
    include ShallowAttributes

    attribute :origin_label, String
    attribute :destination_label, String
    attribute :trip_distance, Float
    attribute :trip_minutes, Float
    attribute :truck_stops_on_route, Array, of: TruckStop
    attribute :has_relaxed_restrictions, Boolean
    attribute :estimated_toll_charges, Float
    attribute :estimated_fuel_cost, Float
    attribute :average_retail_price_per_gallon, Float
    attribute :response_message, String
    attribute :response_status, Integer
    attribute :routing_method, Integer
  end
end