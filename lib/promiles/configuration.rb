# frozen_string_literal: true

require 'singleton'

# Basic configuration class to setup the client configuration.
#
# Example:
#
# Configuration.configure do |config|
#   config.host   = 'https://foo.bar'
#   config.logger = 'log/foo-bar.log'
# end
module Promiles
  class Configuration
    include Singleton

    attr_writer :host, :logger, :cache_duration, :timeout, :open_timeout

    def host
      @host ||= 'http://primebeta.promiles.com'
    end

    def timeout
      @timeout || 10
    end

    def open_timeout
      @open_timeout || 10
    end


    # Public: Returns an instance of a Logger.
    # It will make sure to return a Logger even if only the path for the log
    # is given.
    #
    # returns Logger.
    def logger
      @logger ||= defined?(Rails) ? Rails.logger : Logger.new(STDOUT)
    end

    def logger=(logger)
      logger = Logger.new(logger) if logger.is_a?(String)
      @logger = logger
    end

    def cache_duration
      @cache_duration ||= 5.minutes
    end

    # Public: Configuration setup.
    #
    # Example:
    #
    # Configuration.configure do |config|
    #   config.host   = 'https://foo.bar'
    #   config.logger = 'log/service.log'
    # end
    #
    # Configuration.instance.host = 'https://foo.bar'
    #
    def self.configure(&block)
      yield(instance) if block.present?
      instance
    end
  end

end
