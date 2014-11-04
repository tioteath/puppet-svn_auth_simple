require 'spec_helper'

describe 'svn_realm_string_digest' do
  before :each do
    @mock_http_response = double 'http_response',
        :get_fields => ['Basic realm="Subversion Repository"']
    @mock_http = double 'http',
        :get => @mock_http_response,
        :use_ssl= => nil

    Net::HTTP.stub(:new).and_return @mock_http
  end


  it 'raises exception if malformed or unsupported URI passed' do
    expect {  subject.call ['svn://github.com'] }.to raise_exception ArgumentError
  end


  it 'returns svn:realmstring digest' do
    expect(@mock_http).to receive(:get).twice.ordered.with '/svn/repo'

    # printf -- "<https://svn.example.com:443> Subversion Repository" | md5sum
    expect(subject.call ['https://svn.example.com/svn/repo']).to eq '5eedea0b2a319efdfbdff13e8fc9daae'

    # printf -- "<http://svn.example.com:80> Subversion Repository" | md5sum
    expect(subject.call ['http://svn.example.com/svn/repo']).to eq 'cdc0c76f1779d31e65924a4773e71d54'
  end
end
