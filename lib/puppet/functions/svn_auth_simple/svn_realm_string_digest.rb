# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
require 'uri'
require 'net/http'
require 'net/https'
require 'digest/md5'

# ---- original file header ----
#
# @summary
#         Returns  svn:realmstring for given svn URI. Only HTTP/HTTPS URIs are
#      currently supported.
#
#      This function expects one argument:
#      - Subversion URI.
#
#
Puppet::Functions.create_function(:'svn_auth_simple::svn_realm_string_digest') do
  # @param args
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :args
  end


  def default_impl(*args)
    

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
