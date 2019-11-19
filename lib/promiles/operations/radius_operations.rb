# frozen_string_literal: true
require 'digest'

module Promiles
  module Operations
    module RadiusOperations
      attr_writer :center_location, :radius

      def get_radius(center_location={}, radius=20, cache_duration: configuration.cache_duration)
        @center_location = center_location
        @radius = radius
        cache_key = Digest::SHA1.hexdigest(@center_location.values.join(' ') + @radius.to_s)

        http_response = cached_request(cache_key, cache_duration) do
          connection.post do |req|
            req.url radius_endpoint
            req.headers['Content-Type'] = 'application/json'
            req.body = radius_params
          end
        end

        response = process_response(http_response)

        if response.success?
          Promiles::Radius.new(response.body)
        end
      end

      private

      def radius_endpoint
        '/WebAPI/api/truckstopsinradius'
      end

      def radius_params
        {
          center_location: @center_location,
          radius: @radius,
          apikey: @apikey
        }.deep_transform_keys{ |key| key.to_s.camelize }.to_json
      end
    end
  end
end
