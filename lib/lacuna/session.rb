# encoding: utf-8

class Session
    @@session = nil

    def self.set(val)
        @@session = val
    end

    def self.end
        self.set nil
    end

    def self.get
        @@session
    end

    def self.valid?
        # TODO: take into account the two hour session timeout.
        !@@session.nil?
    end
end
