# frozen_string_literal: true

module Promiles
  module Operations
    module TruckStopsOperations

      def get_truck_stops
        truck_stops
      end

      def get_truck_stop(pro_miles_tsid)
        truck_stops.select { |truck_stop| truck_stop.pro_miles_tsid == pro_miles_tsid }.first
      end

      private

      def truck_stops
        @truck_stops ||= get_promiles_truck_stops
      end

      def get_promiles_truck_stops(cache_duration: configuration.cache_duration)
        http_response = cached_request(cache_key, cache_duration) do
          connection.get do |req|
            req.url csv_endpoint
            req.headers['Content-Type'] = 'application/csv'
          end
        end

        response = process_response(http_response)

        if response.success?
          return process_csv(response.body.drop(1))
        end

        return []
      end

      def csv_endpoint
        "/WebAPI/api/GetTruckStopsWithOpisCSV/?apikey=#{@apikey}"
      end

      def cache_key
        'truck_stops_csv'
      end

      def process_csv(csv_body)
        csv_body.reduce([]) { |acc, row| acc << row_values(row) }
      end

      def row_values(row)
        Promiles::TruckStop.new({
          pro_miles_tsid: row[0],
          name: row[2],
          chain: row[3],
          location: row[4],
          city: row[5],
          state: row[6],
          zip: row[7],
          phone: row[8],
          latitude: row[9],
          longitude: row[10],
          retail_price: row[11],
          price_date: row[12],
          opis_retail: row[14],
          opis_cost: row[15],
          opis_price_date: row[16]
        })
      end
    end
  end
end
