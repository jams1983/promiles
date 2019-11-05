# frozen_string_literal: true

module Promiles
  class Amenity
    include ShallowAttributes

    attribute :name, String
    attribute :category, String
    attribute :value, String
  end
end