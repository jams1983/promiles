# frozen_string_literal: true

module Promiles
  module Operations
    module TruckStopsOperations
      def get_truck_stop(pro_miles_tsid)
        @pro_miles_tsid = pro_miles_tsid
        truck_stop
      end

      private

      def truck_stop
        get_promiles_truck_stop
      end

      def get_promiles_truck_stop(cache_duration: configuration.cache_duration)
        cache_key = "truck_stops_#{@pro_miles_tsid}"
        http_response = cached_request(cache_key, cache_duration) do
          connection.get do |req|
            req.url truck_stop_endpoint
            req.headers['Content-Type'] = 'application/json'
          end
        end

        response = process_response(http_response)

        if response.success?
          Promiles::TruckStop.new(response.body)
        end
      end

      def truck_stop_endpoint
        "/WebApi/api/truckstop/#{@apikey}/#{@pro_miles_tsid}"
      end
    end
  end
end
