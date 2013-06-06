# Lapse

Lapse, as in teeter-Lapse, let's you work with the Seesaw API in Ruby.

All networking is done with Net::HTTP so you don't have to worry about version conflicts with whatever networking library you may be using.

Read the [documentation](http://rubydoc.info/github/seesawco/Lapse-rb/master/frames) online.

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'Lapse'
```

And then execute:

``` shell
$ bundle
```

Or install it yourself as:

``` shell
$ gem install Lapse
```

## Configuration

Should you wish to configure the client in an initializer, you can do the following:

``` ruby
Lapse::Client.configure do |client|
  client.api_host = "some.api-host.com"
  client.api_scheme = "http"
end
```

## Usage

A client takes an optional access token when you initialize it. If you don't provide one, you can still use it to make unauthenticated requests. If you do provide one, it will set the authorization header for all requests.


## Supported Ruby Versions

Lapse is tested under 1.8.7, 1.9.2, 1.9.3, 2.0.0, JRuby 1.7.2 (1.9 mode), and Rubinius 2.0.0 (1.9 mode).

## Contributing

See the [contributing guide](Contributing.markdown).
