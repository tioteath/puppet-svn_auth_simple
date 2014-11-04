require 'uri'
require 'net/http'
require 'net/https'
require 'digest/md5'

module Puppet::Parser::Functions
  newfunction :svn_realm_string_digest,
      :type => :rvalue, :doc => <<-'DOC' do |args|
      Returns  svn:realmstring for given svn URI. Only HTTP/HTTPS URIs are
      currently supported.

      This function expects one argument:
      - Subversion URI.
    DOC

    uri = args.first
    raise ArgumentError,
        "URI is empty." if uri.nil? or uri.empty?
    raise ArgumentError,
        "Malformed URI: #{uri}." unless URI.regexp(['http', 'https']).match uri

    uri = URI.parse uri

    http         = Net::HTTP.new uri.host, uri.port
    http.use_ssl = uri.scheme.eql? 'https'
    response     = http.get uri.request_uri

    auth_field = response.get_fields('WWW-Authenticate')
    if auth_field.kind_of? Array
      realm = auth_field.first.split('=').last.gsub /(^")|("$)/, ''
    else
      realm = ''
    end
    realm_string = "<#{uri.scheme}://#{uri.host}:#{uri.port}> #{realm}".strip

    [realm_string, Digest::MD5.hexdigest(realm_string)]
  end
end
