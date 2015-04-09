require 'base64'
require 'digest'
require 'openssl'

require 'mojo_auth/version'

# MojoAuth is a set of standard approaches to cross-app authentication based on HMAC
#
# @example Typical usage
#   require 'mojo_auth'
#
#   # Generate a shared secret
#   secret = MojoAuth.create_secret
#     # => "XyD+xeJHivzbOUe3vwdU6Z5vDe/vio34MxKX8HYViR0+p4t/NzaIpbK+9VwX\n5qHCj7m4f7UNRXgOJPXzn6MT0Q=="
#
#   # Create temporary credentials
#   credentials = MojoAuth.create_credentials(id: 'foobar', secret: secret)
#     # => {:username=>"1411837760:foobar", :password=>"wb6KxLj6NXcUaqNb1SlHH1V3QHw="}
#
#   # Test credentials
#   MojoAuth.test_credentials({username: "1411837760:foobar", password: "wb6KxLj6NXcUaqNb1SlHH1V3QHw="}, secret: secret)
#     # => "foobar"
#   MojoAuth.test_credentials({username: "1411837760:foobar", password: "wrongpassword"}, secret: secret)
#     # => false
#
#   # 1 day later
#   MojoAuth.test_credentials({username: "1411837760:foobar", password: "wb6KxLj6NXcUaqNb1SlHH1V3QHw="}, secret: secret)
#     # => false
#
class MojoAuth
  DAY_IN_SECONDS = 86_400

  # Create a new random secret
  #
  # @return [String] a new secret based on /dev/random
  def self.create_secret
    random = File.read('/dev/random', 512)
    Base64.encode64(Digest::SHA2.new(512).digest(random))
  end

  # Create a new credential set
  #
  # @param [String] id the identity to be asserted in the credentials
  # @param [String] secret the shared secret with which to create credentials
  # @param [Integer] ttl the duration for which the credentials should be valid in seconds
  #
  # @return [Hash] signed credentials, keys :username and :password
  #
  # @example Basic usage
  #   credentials = MojoAuth.create_credentials(secret: secret)
  #   # => {:username=>"1411837760", :password=>"wb6KxLj6NXcUaqNb1SlHH1V3QHw="}
  #
  # @example Asserting an identity
  #   credentials = MojoAuth.create_credentials(id: 'foobar', secret: secret)
  #   # => {:username=>"1411837760:foobar", :password=>"wb6KxLj6NXcUaqNb1SlHH1V3QHw="}
  #
  # @example Specifying an alternative TTL
  #   credentials = MojoAuth.create_credentials(ttl: 600, secret: secret)
  #   # => {:username=>"1411837760", :password=>"wb6KxLj6NXcUaqNb1SlHH1V3QHw="}
  #
  def self.create_credentials(id: nil, secret: required, ttl: DAY_IN_SECONDS)
    expiry_timestamp = (Time.now.utc + ttl).to_i
    username = [expiry_timestamp, id].join(':')
    { username: username, password: new(secret).sign(username) }
  end

  # Test that credentials are valid
  #
  # @param [Hash] credentials a set of credentials including a :username and a :password
  # @param [String] secret the shared secret against which to test credentials
  #
  # @return [Boolean, String] whether or not the credentials are valid (were created using the specified secret) and current (have not yet expired). When the credentials assert an identity, that identity is returned.
  #
  # @example Testing correct credentials
  #   MojoAuth.test_credentials({username: "1411837760", password: "wb6KxLj6NXcUaqNb1SlHH1V3QHw="}, secret: secret)
  #   # => true
  #
  # @example Testing correct ID-asserting credentials
  #   MojoAuth.test_credentials({username: "1411837760:foobar", password: "wb6KxLj6NXcUaqNb1SlHH1V3QHw="}, secret: secret)
  #   # => "foobar"
  #
  # @example Testing incorrect credentials
  #   MojoAuth.test_credentials({username: "1411837760:foobar", password: "wrongpassword"}, secret: secret)
  #   # => false
  #
  def self.test_credentials(credentials, secret: required)
    new(secret).assert(credentials)
  end

  # Work-around for required named parameters pre Ruby 2.1
  # @private
  def self.required
    method = caller_locations(1, 1)[0].label
    fail ArgumentError, "A required keyword argument was not specified when calling '#{method}'"
  end

  # Create a MojoAuth instance
  #
  # @param [String] secret the shared secret to sign credentials with
  def initialize(secret)
    @secret = secret
  end

  # Sign a message via HMAC-SHA1
  #
  # @param [String] message the message to be signed
  #
  # @return [String] the message signed with the shared secret
  def sign(message)
    Base64.encode64(OpenSSL::HMAC.digest('sha1', @secret, message)).chomp
  end

  # Assert a set of credentials
  #
  # @param [Hash] credentials a set of credentials including a :username and a :password
  # @param [String] secret the shared secret against which to test credentials
  #
  # @return [Boolean, String] whether or not the credentials are valid (were created using the specified secret) and current (have not yet expired). When the credentials assert an identity, that identity is returned.
  def assert(credentials)
    expiry_timestamp, id = credentials[:username].split(':')
    return false if expiry_timestamp.to_i < Time.now.utc.to_i
    return false unless sign(credentials[:username]) == credentials[:password]
    id || true
  end
end
