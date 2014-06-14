# encoding: utf-8

class Session
    @id = nil
    attr_accessor :id

    def valid?
        # TODO: take into account the two hour session timeout.
        !self.id.nil?
    end
end
