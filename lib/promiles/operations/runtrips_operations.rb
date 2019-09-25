# frozen_string_literal: true

module Promiles
  module Operations
    module RuntripsOperations
      attr_writer :trip_legs, :opts

      def get_runtrip(trip_legs=[], opts={}, cache_duration: configuration.cache_duration)
        @trip_legs = trip_legs
        @opts = opts

        http_response = cached_request('promiles_runtrips', cache_duration) do
          connection.post do |req|
            req.url endpoint
            req.headers['Content-Type'] = 'application/json'
            req.headers['apikey'] = @apikey
            req.body = params
          end
        end

        response = process_response(http_response)

        if response.success?
          Promiles::Runtrip.new(response.body)
        end
      end

      private

      def endpoint
        '/WebAPI/api/runtrip'
      end

      def params
        @opts = { get_truck_stops_on_route: true } if @opts.blank?

        @opts.merge!(trip_legs: @trip_legs, apikey: @apikey)
        @opts.deep_transform_keys{ |key| key.to_s.camelize }.to_json
      end


    end
  end
end
