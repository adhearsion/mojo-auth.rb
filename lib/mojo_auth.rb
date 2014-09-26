require 'base64'
require 'digest'

require 'mojo_auth/version'

#
# MojoAuth
#
# MojoAuth is a set of standard approaches to cross-app authentication based on HMAC
#
module MojoAuth
  # Create a new random secret
  # @return [String] a new secret based on /dev/random
  def self.create_secret
    random = File.read('/dev/random', 512)
    Base64.encode64(Digest::SHA2.new(512).digest(random))
  end
end
