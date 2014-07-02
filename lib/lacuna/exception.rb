# encoding: utf-8

module Lacuna
    class Exception < StandardError
        # Generic Exception for Lacuna.
    end

    class RPCException < Lacuna::Exception
        attr_reader :object
        attr_reader :message
        attr_reader :code
        attr_reader :data

        def initialize(object)
            @object = object
            @message = object['message'].to_s
            @code = object['code'].to_i
            @data = object['data'].to_s
        end
    end

    class TaskException < Lacuna::RPCException
        # Same class, different name. Should only be used by tasks.
    end
end
