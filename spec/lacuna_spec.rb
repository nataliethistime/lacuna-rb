# encoding: utf-8

require './lib/lacuna'

describe Lacuna do
    it 'should define all the RPC modules of the Lacuna server' do
        expect(Lacuna::Alliance).to_not be_nil
        expect(Lacuna::Empire).to_not be_nil
        expect(Lacuna::Inbox).to_not be_nil
        expect(Lacuna::Stats).to_not be_nil
        expect(Lacuna::Map).to_not be_nil
        expect(Lacuna::Body).to_not be_nil
        expect(Lacuna::Buildings).to_not be_nil
        expect(Lacuna::Captcha).to_not be_nil
    end
end

describe Lacuna::Module, '#send' do

    before :each do
        Lacuna.connect({
            :name => 'lacuna-rb Test Account',
            :password => '123qwe',
            :server_name => 'pt',
        })
    end

    it 'should return data' do
        status = Lacuna::Empire.get_status
        expect(status).to_not be_nil
        expect(status['empire']['name']).to eq 'lacuna-rb Test Account'

        body = Lacuna::Body.get_status status['empire']['home_planet_id']
        expect(body['body']['name']).to eq 'Ruby'
    end
end
