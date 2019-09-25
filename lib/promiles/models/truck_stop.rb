# frozen_string_literal: true

module Promiles
  class TruckStop
    include ShallowAttributes

    attribute :pro_miles_tsid, Integer
    attribute :name, String
    attribute :state, String
    attribute :city, String
    attribute :zip, String
    attribute :location, String
    attribute :chain, String
    attribute :distance_from_origin, Float
    attribute :distance_oor, Float
    attribute :retail_price, Float
    attribute :ex_tax_price, Float
    attribute :state_tax, Float
    attribute :price_date, String
    attribute :latitude, Float
    attribute :longitude, Float
  end
end