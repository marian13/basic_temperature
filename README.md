<!-- header:start -->
<h1 align="center">
  Basic Temperature
</h1>
<!-- header:end -->

<!-- badges:start -->
[![Gem Version](https://badge.fury.io/rb/basic_temperature.svg)](https://rubygems.org/gems/basic_temperature) [![GitHub Actions CI](https://github.com/marian13/basic_temperature/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/marian13/basic_temperature/actions/workflows/ci.yml) [![Maintainability](https://api.codeclimate.com/v1/badges/21dc5d50cf5de8346a3c/maintainability)](https://codeclimate.com/github/marian13/basic_temperature/maintainability) [![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard) [![Coverage Status](https://coveralls.io/repos/github/marian13/basic_temperature/badge.svg)](https://coveralls.io/github/marian13/basic_temperature?branch=main) [![Inline docs](http://inch-ci.org/github/marian13/basic_temperature.svg?branch=master)](http://inch-ci.org/github/marian13/basic_temperature)
[![Patreon](https://img.shields.io/badge/patreon-donate-orange.svg)](https://www.patreon.com/user?u=31435716&fan_landing=true)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges:end -->

<!-- logo:start -->
<p align="center">
  <img src="https://raw.githubusercontent.com/marian13/basic_temperature/master/logo.png">
</p>
<!-- logo:end -->

<!-- general_description:start -->
`basic_temperature` is a Ruby library which provides a simple [value object](https://martinfowler.com/bliki/ValueObject.html) to work with temperatures and 
allows to perform basic operations like conversion from Celsius to Kelvin, from Kelvin to Fahrenheit etc.
<!-- general_description:end -->

<!-- features:start -->
### Features
- Provides a `Temperature` class which encapsulates all information about a certain  temperature, such
as its amount of degrees and its scale.
- Provides APIs for exchanging temperatures from one scale to another (currently Celsius, Fahrenheit, Kelvin and
Rankine).

- Allows comparing temperatures between each other.
- Queries like `boil_water?`, `freeze_water?`.
- Tested against Ruby 2.3, 2.4, 2.5, 2.6, 2.7, 3.0 and 3.1. See [.github/workflows/ci.yml](https://github.com/marian13/basic_temperature/blob/main/.github/workflows/ci.yml).
<!-- features:end -->

<!-- dependencies:start -->
### Dependencies

* None.
<!-- dependencies:end -->

<!-- documentation:start -->
### Documentation

* Visit https://marian13.github.io/basic_temperature/ to view the documentation.
<!-- documentation:end -->

<!-- installation:start -->
## Installation

Gemfile:

```ruby
gem 'basic_temperature', '~> 1.0.0'
```

And then run:

    $ bundle install

And that's it.

You can access all the features of `basic_temperature` by creating instances of `BasicTemperature::Temperature`.

But there is a shorter form.

If `Temperature` constant was not used before in your app, you can add this line to your Gemfile:

```ruby
gem 'basic_temperature', '~> 1.0.0', require: ['basic_temperature/alias']
```

This way `BasicTemperature::Temperature` class will be accesible simply by `Temperature`.

The following guide assumes you have chosen the shorter form.

If not, just replace all `Temperature` to `BasicTemperature::Temperature`.
<!-- installation:end -->

<!-- usage:start -->
## Usage

### Creating Temperatures

A new temperature can be created in multiple ways:

- Using keyword arguments:

```ruby
Temperature.new(degrees: 0, scale: :celsius)
```

- Using positional arguments:

```ruby
Temperature.new(0, :celsius)
```

- Even more concise way using `Temperature.[]` (an alias of `Temperature.new`):

```ruby
Temperature[0, :celsius]
```

### Creating Temperatures from already existing temperature objects

Sometimes it is useful to create a new temperature from an already existing one.

For such cases, there are `set_degrees` and `set_scale`.

Since temperatures are [value objects](https://martinfowler.com/bliki/ValueObject.html), both methods return
new instances.

Examples:

```ruby
temperature = Temperature[0, :celsius]
# => 0 °C

new_temperature = temperature.set_degrees(15)
# => 15 °C

temperature = Temperature[0, :celsius]
# => 0 °C

new_temperature = temperature.set_scale(:kelvin)
# => 0 K
```

### Conversions

Temperatures can be converted to different scales.

Currently, the following scales are supported: `Celsius`, `Fahrenheit`, `Kelvin` and `Rankine`.

```ruby
Temperature[20, :celsius].to_celsius
# => 20 °C

Temperature[20, :celsius].to_fahrenheit
# => 68 °F

Temperature[20, :celsius].to_kelvin
# => 293.15 K

Temperature[20, :celsius].to_rankine
# => 527.67 °R
```

If it is necessary to convert scale dynamically, `to_scale` method is available.

```ruby
Temperature[20, :celsius].to_scale(scale)
```

All conversion formulas are taken from
[RapidTables](https://www.rapidtables.com/convert/temperature/index.html).

Conversion precision: 2 accurate digits after the decimal dot.

### Comparison

Temperature implements idiomatic [<=> spaceship operator](https://ruby-doc.org/core/Comparable.html) and mixes in [Comparable](https://ruby-doc.org/core/Comparable.html) module.

As a result, all methods from [Comparable](https://ruby-doc.org/core/Comparable.html) are available, e.g:

```ruby
Temperature[20, :celsius] < Temperature[25, :celsius]
# => true

Temperature[20, :celsius] <= Temperature[25, :celsius]
# => true

Temperature[20, :celsius] == Temperature[25, :celsius]
# => false

Temperature[20, :celsius] > Temperature[25, :celsius]
# => false

Temperature[20, :celsius] >= Temperature[25, :celsius]
# => false

Temperature[20, :celsius].between?(Temperature[15, :celsius], Temperature[25, :celsius])
# => true

# Starting from Ruby 2.4.6
Temperature[20, :celsius].clamp(Temperature[20, :celsius], Temperature[25, :celsius])
# => 20 °C
```

Please note, if the second temperature has a different scale, the first temperature is automatically
converted to that scale before comparison.

```ruby
Temperature[20, :celsius] == Temperature[293.15, :kelvin]
# => true
```

#### IMPORTANT !!!

`degrees` are rounded to the nearest value with a precision of 2 decimal digits before comparison.

This means the following temperatures are considered as equal:

```ruby
Temperature[20.020, :celsius] == Temperature[20.024, :celsius]
# => true

Temperature[20.025, :celsius] == Temperature[20.029, :celsius]
# => true
```

while these ones are treated as NOT equal:

```ruby
Temperature[20.024, :celsius] == Temperature[20.029, :celsius]
# => false
```

### Queries
```ruby
Temperature[0, :celsius].boil_water?
# => false

Temperature[0, :celsius].freeze_water?
# => true
```
<!-- usage:end -->

<!-- versioning:start -->
## Versioning
Basic Temperature follows the [Semantic Versioning](https://semver.org/) standard.
<!-- versioning:end -->

<!-- contributing:start -->
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marian13/basic_temperature.
<!-- contributing:end -->

<!-- development:start -->
## Development

### Local Machine

* Check specs:
  ```bash
  bundle exec rspec
  ```

* Check linter:
  ```bash
  bundle exec rubocop
  ```

* Update docs:
  ```bash
  bundle exec sdoc lib -T rails -o docs
  ```

* Find missed docs:
  ```bash
  bundle exec inch
  ```

* Check for vulnerable gem versions, insecure gem sources, etc...
  ```bash
  bundle exec bundle-audit check --update
  ```

### Docker

* Build container:
  ```bash
  docker build . -f docker/3.1/Dockerfile -t basic_temperature:3.1
  ```

* Run specs inside the container:
  ```bash
  docker run --rm -it basic_temperature:3.1 bundle exec rspec
  ```

* Interactive Bash shell:
  ```bash
  docker run --rm -it basic_temperature:3.1 bash
  ```

* Ruby REPL with already required gem files:
  ```bash
  docker run --rm -it basic_temperature:3.1 bin/console
  ```

* `3.1` can be replaced by `2.3`, `2.4`, `2.5`, `2.6`, `2.7`, and `3.0`.
<!-- development:end -->

<!-- license:start -->
## License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
<!-- license:end -->

<!-- author:start -->
Copyright (c) 2022 [Marian Kostyk](http://mariankostyk.com).
<!-- author:end -->
