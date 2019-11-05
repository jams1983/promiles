# frozen_string_literal: true
require 'digest'

module Promiles
  module Operations
    module RuntripsOperations
      attr_writer :trip_legs, :opts

      def get_runtrip(trip_legs=[], opts={}, cache_duration: configuration.cache_duration)
        @trip_legs = trip_legs
        @opts = opts
        cache_key = Digest::SHA1.hexdigest(@trip_legs.map { |trip_leg| trip_leg.values }.join(' '))

        http_response = cached_request(cache_key, cache_duration) do
          connection.post do |req|
            req.url runtrip_endpoint
            req.headers['Content-Type'] = 'application/json'
            req.body = runtrip_params
          end
        end

        response = process_response(http_response)

        if response.success?
          Promiles::Runtrip.new(response.body)
        end
      end

      private

      def runtrip_endpoint
        '/WebAPI/api/runtrip'
      end

      def runtrip_params
        @opts = { get_truck_stops_on_route: true } if @opts.blank?

        @opts.merge!(trip_legs: @trip_legs, apikey: @apikey)
        @opts.deep_transform_keys{ |key| key.to_s.camelize }.to_json
      end
    end
  end
end
