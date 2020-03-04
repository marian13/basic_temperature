## Basic Temperature ##

[![Gem Version](https://badge.fury.io/rb/basic_temperature.svg)](https://rubygems.org/gems/basic_temperature) [![Build Status](https://travis-ci.com/marian13/basic_temperature.svg?branch=master)](https://travis-ci.com/marian13/basic_temperature) [![Maintainability](https://api.codeclimate.com/v1/badges/21dc5d50cf5de8346a3c/maintainability)](https://codeclimate.com/github/marian13/basic_temperature/maintainability) [![Coverage Status](https://coveralls.io/repos/github/marian13/basic_temperature/badge.svg)](https://coveralls.io/github/marian13/basic_temperature)
[![Patreon](https://img.shields.io/badge/patreon-donate-orange.svg)](https://www.patreon.com/user?u=31435716&fan_landing=true)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

![alt text](https://raw.githubusercontent.com/marian13/basic_temperature/master/logo.png)

Basic Temperature is a Ruby library which provides a simple value object to work with temperatures and allows to perform basic operations like conversion from Celcius to Kelvin, from Kelvin to Fahrenheit etc.

### Features
- Provides a `BasicTemperature` class which encapsulates all information about a certain
  temperature, such as its amount of degrees and its scale.
- Provides APIs for exchanging temperatures from one scale to another (currently Celsius, Kelvin and Fahrenheit).
- Allows comparing temperatures between each other.
- Supports basic math operations like addition and subtraction.
- Tested against Ruby 2.3, 2.4, 2.5, 2.6 & 2.7. See [.travis-ci.yml](https://github.com/marian13/basic_temperature/blob/9b13cb9909b57c51bb5dc05a8989d07a314e67d6/.travis.yml) for the exact versions.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'basic_temperature'
```

#### Warning

Since this gem is under active development and there are often backward-incompatible changes between minor releases, you might want to use a conservative version lock in your Gemfile:

```ruby
gem 'basic_temperature', '~> 0.2.1'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install basic_temperature

## Usage

```ruby
require 'basic_temperature'

temperature = BasicTemperature.new(degrees: 20, scale: :celcius)
# Scale can be one of celcius, kelvin or fahrenheit.

temperature.to_celcius
# => 20 Celcius

temperature.to_kelvin
# => 293 Kelvin

temperature.to_fahrenheit
# => 68 Fahrenheit
```

You can try to utilize `BasicTemperature#to_scale` if you need to convert temperatures dynamically, for example:

```ruby
temperature.to_scale(scale)
```

Temperatures can be compared between each other.

```ruby
temperature = BasicTemperature.new(degress: 0, scale: :celcius)

other = BasicTemperature.new(degress: 0, scale: :celcius)

temperature == other
# => true
```

When temperatures have different scales - conversion to common scale is handled under the hood.
```ruby
temperature = BasicTemperature.new(degress: 0, scale: :celcius)

other = BasicTemperature.new(degress: 273.15, scale: :kelvin)

temperature == other
# => true
```

## Versioning
Basic Temperature follows the [Semantic Versioning](https://semver.org/) standard.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marian13/basic_temperature.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

Copyright (c) 2020 [Marian Kostyk](http://mariankostyk.com).
