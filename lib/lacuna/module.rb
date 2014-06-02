# encoding: utf-8

module Lacuna
    class Module
        def self.send(url, post_module, post_method, data)
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

            # Include session id in requests that need it
            if "#{post_module}/#{post_method}" != 'empire/login'
                body[:params].unshift Session.get
            end

            request.body = JSON.generate body

            response = http.request request
            rv = JSON.parse response.read_body

            if rv['result']
                rv['result']
            elsif rv['error']
                # TODO: throw error?
                p rv['error']
                rv['error']
            else
                rv
            end
        end

        # Check that we're logged in, if not, get session a set up.
        def self.session_stuff
            if !Session.valid?
                res = self.send(Lacuna.url, 'empire', 'login', [
                    Lacuna.args[:name],
                    Lacuna.args[:password],
                    Lacuna.api_key,
                ])
                Session.set res['session_id']
            else
                # check time
                return
            end
        end

        def self.method_missing(name, *args)
            if !@module_name.nil?
                self.session_stuff
                self.send(Lacuna.url, @module_name, name.id2name, args)
            else
                puts "#{self} isn't working!"
            end
        end
    end
end
