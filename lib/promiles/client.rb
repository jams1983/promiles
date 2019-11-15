# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/numeric'
require 'faraday'
require 'faraday/request_id'
require 'csv'

require_relative 'operations/runtrips_operations'
require_relative 'operations/csv_truck_stops_operations'
require_relative 'operations/truck_stops_operations'
require_relative 'operations/radius_operations'

module Promiles
  class Client
    include Operations::RuntripsOperations
    include Operations::CsvTruckStopsOperations
    include Operations::RadiusOperations
    include Operations::TruckStopsOperations

    attr_writer :apikey, :host

    def initialize(apikey, host)
      @apikey = apikey
      @host = host
    end

    def configuration
      @configuration ||= Configuration.instance
    end

    def connection_headers
      {}
    end

    def connection
      @connection ||= Faraday.new(@host) do |builder|
        builder.request  :url_encoded             # form-encode POST params
        builder.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        #builder.response :logger                  # log requests to $stdout
      end
    end

    private

    def raise_error?
      false
    end

    def cached_request(cache_key, expires_in)
      if cache_key && expires_in && defined?(Rails)
        Rails.cache.fetch(cache_key, expires_in: expires_in) do
          yield
        end
      else
        yield
      end
    end

    # Register error log for a request and return json result
    def handle_error(errors, status, content_type)
      if defined?(Rails)
        Rails.logger.warn "RESPONSE STATUS: #{status}"
        Rails.logger.warn errors
      end

      OpenStruct.new(success?: false, status: status, body: { errors: errors }, content_type: content_type)
    end

    # General method to handle the JSON response for any service
    def process_response(response)
      content_type = content_type_for(response)
      result = process_body(response.body)

      if response.success?
        case content_type_for(response)
        when :csv
          OpenStruct.new(success?: true, status: response.status, content_type: content_type, body: CSV.parse(result))
        else
          OpenStruct.new(success?: true, status: response.status, content_type: content_type, body: parse_body(result))
        end
      else
        handle_error(result, response.status, content_type)
      end
    end

    def process_body(body)
      return {} if body.blank?
      body
    end

    def parse_body(body)
      result = JSON.parse(body)
      result.is_a?(Hash) ? result.deep_transform_keys{ |key| key.to_s.underscore.to_sym } : {}
    rescue JSON::ParserError
      {}
    end

    def content_type_for(response)
      case response.headers['content-type']
      when /json/i
        :json
      when /xml/i
        :xml
      when /html/i
        :html
      when /csv/i
        :csv
      else
        :plain_text
      end
    end
  end
end
