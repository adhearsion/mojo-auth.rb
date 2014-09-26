require 'bundler/setup'
Bundler.setup

require 'coveralls'
Coveralls.wear!

require 'timecop'
Timecop.safe_mode = true

require 'mojo_auth'

RSpec.configure do
end
