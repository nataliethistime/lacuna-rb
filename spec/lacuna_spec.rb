# encoding: utf-8

require './lib/lacuna'

describe LacunaModule, '#send' do

    before :each do
        @lacuna = Lacuna.new({
            :name => 'your-empire',
            :password => 'enter-your-password',
            :server_name => 'us1',
        })
    end

    it 'should return data' do
        status = @lacuna.empire.get_status
        expect(status).to_not be_nil
    end
end
