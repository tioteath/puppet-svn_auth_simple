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
    raise ArgumentError, "Malformed URI" unless
        URI.regexp(['http', 'https']).match uri

    uri = URI.parse uri

    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = (uri.scheme.eql? 'https')
    response = http.get uri.request_uri

    auth_realm = response.get_fields('WWW-Authenticate').first.
        split('=').last.gsub(/(^")|("$)/, '') #|| 'Subversion Repository'

    Digest::MD5.hexdigest "<#{uri.scheme}://#{uri.host}:#{uri.port}> " \
        "#{auth_realm}"
  end
end
