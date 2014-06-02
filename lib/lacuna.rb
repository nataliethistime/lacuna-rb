# encoding: utf-8


$LOAD_PATH.unshift File.dirname __FILE__

require 'net/http'
require 'openssl'
require 'json'
require 'require_all'

require 'lacuna/version'
require 'lacuna/session'
require 'lacuna/constants'
require 'lacuna/module'

require_all File.join(File.dirname(__FILE__), 'lacuna', 'extras')

module Lacuna

    def self.connect(args)
        # Allow a custom server url, be specifying the API key used there but
        # allow the name of the server (eg: 'us1') to be used, which selects
        # the API key corresponding to US1.
        @@api_key =
            if args[:api_key]
                args[:api_key]
            elsif args[:server_name] && !args[:server_url]
                API_KEYS[args[:server_name]]
            end

        @@url =
            if args[:server_url]
                args[:server_url]
            elsif args[:server_name]
                File.join('https://', args[:server_name] + '.' + LACUNA_DOMAIN)
            end

        @@args = args

        # TODO: allow a sleep-period for each request
    end

    @@url     = ''
    @@args    = {}
    @@api_key = ''
    def self.url;     @@url;     end
    def self.args;    @@args;    end
    def self.api_key; @@api_key; end

    class Empire < Lacuna::Extras::Empire
        @module_name = 'empire'
    end

    class Body < Lacuna::Extras::Body
        @module_name = 'body'
    end
end
