[![Gem Version](https://badge.fury.io/rb/mojo_auth.png)](https://rubygems.org/gems/mojo_auth)
[![Build Status](https://secure.travis-ci.org/mojolingo/mojo-auth.rb.png?branch=develop)](http://travis-ci.org/mojolingo/mojo-auth.rb)
[![Dependency Status](https://gemnasium.com/mojolingo/mojo-auth.rb.png?travis)](https://gemnasium.com/mojolingo/mojo-auth.rb)
[![Code Climate](https://codeclimate.com/github/mojolingo/mojo-auth.rb.png)](https://codeclimate.com/github/mojolingo/mojo-auth.rb)
[![Coverage Status](https://coveralls.io/repos/mojolingo/mojo-auth.rb/badge.png?branch=develop)](https://coveralls.io/r/mojolingo/mojo-auth.rb)
[![Inline docs](http://inch-ci.org/github/mojolingo/mojo-auth.rb.png?branch=develop)](http://inch-ci.org/github/mojolingo/mojo-auth.rb)

# mojo_auth

[MojoAuth](http://mojolingo.com/mojoauth) is a set of standard approaches to cross-app authentication based on [Hash-based Message Authentication Codes](http://en.wikipedia.org/wiki/Hash-based_message_authentication_code) (HMAC), inspired by ["A REST API For Access To TURN Services"](http://tools.ietf.org/html/draft-uberti-behave-turn-rest).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mojo_auth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mojo_auth

## Usage

```ruby
require 'mojo_auth'

# Generate a shared secret
secret = MojoAuth.create_secret # => "tiKNcQixBMNJMwf4s+QM1hrb+m0vxGchD1/TxKBC6MesBuLPWewEXwM3b/ka\nZuB4sTCLyB1A7xpnaNKqe7sIjQ==\n"

# Create temporary credentials
credentials = MojoAuth.create_credentials(id: 'foobar', ttl: 86_400, secret: secret) # => {username: '1411779321:foobar', password: 'correctpassword'}

# Test credentials
MojoAuth.test_credentials(username: '1411779321:foobar', password: 'correctpassword') # => true
MojoAuth.test_credentials(username: '1411779321:foobar', password: 'wrongpassword') # => false

# 1 day later
MojoAuth.test_credentials(username: '1411779321:foobar', password: 'correctpassword') # => false
```

## Contributing

1. [Fork it](https://github.com/mojolingo/mojo_auth.rb/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
