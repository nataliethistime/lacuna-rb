# encoding: utf-8


require 'net/http'
require 'openssl'
require 'json'

class Lacuna
    API_KEYS = {
        # Private key : 66090c68-2d51-47fa-b406-44dc98e6f6d3
        'us1' => 'bbd9b648-6e45-419d-bdaf-5726919c4a64',
    }

    LACUNA_DOMAIN = 'lacunaexpanse.com'

    def initialize(args)
        # Allow a custom server url, be specifying the API key used there but
        # allow the name of the server (eg: 'us1') to be used, which selects
        # the API key corresponding to US1.
        @api_key =
            if args[:api_key]
                args[:api_key]
            elsif args[:server_name] && !args[:server_url]
                API_KEYS[args[:server_name]]
            end

        @url =
            if args[:server_url]
                args[:server_url]
            elsif args[:server_name]
                File.join('https://', args[:server_name] + '.' + LACUNA_DOMAIN)
            end

        @args = args

        # TODO: allow a sleep-period for each request
    end

    def method_missing(name, *args)
        args = @args.merge :api_key => @api_key
        LacunaModule.new(@url, name.id2name, args)
    end
end

class LacunaModule

    def initialize(base_url, module_name, args)
        @base_url    = base_url
        @url         = base_url
        @module_name = module_name
        @method_name = 'replace me!'
        @args        = args
    end

    def send(url, post_module, post_method, data)
        uri = URI.parse url
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new '/' + post_module
        request.add_field('Content-Type', 'application/json')

        body = {
            :id      => 1,
            :jsonrpc => '2.0',
            :method  => post_method,
            :params  => data
        }
        if "#{post_module}/#{post_method}" != 'empire/login'
            body[:params].unshift @session_id
        end

        request.body = JSON.generate body

        response = http.request request
        rv = JSON.parse response.read_body

        # TODO: if !rv['error'].nil? throw an exception
        if rv['result']
            rv['result']
        else
            rv
        end
    end

    # Check that we're logged in, if not, get session a set up.
    def session_stuff
        if !@session_id
            res = self.send(@base_url, 'empire', 'login', [
                @args[:name],
                @args[:password],
                @args[:api_key],
            ])
            @session_id = res['session_id']
        else
            # check time
            return
        end
    end

    def method_missing(name, *args)
        @method_name = name.id2name
        self.session_stuff
        self.send(@url, @module_name, @method_name, args)
    end
end
