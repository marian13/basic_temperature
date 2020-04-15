## 1.0.0
### Features:
  - `Temperature#boil_water?`, `Temperature#freeze_water?` (#47).

### Docs
  - Added link to docs in README.md (42).

### Tech improvements:
  - Global refactoring: splitting ot the God Object into modules.
  - [Inch CI](https://inch-ci.org/) setup (#45).

## 0.2.2
### Features:
  - Include Comparable (#24).
  - Introduction of shorter form (`Temperature` instead of `BasicTemperature::Temperature`) (#25).
  - Added simple memoization (#26).
  - Added rounding (#26).
  - Alias `[]` for `new` (#27).
  - Added support of `Rankine` scale.
  - `Temperature#inspect`.

### Fixes:
  - Updated `BasicTemperature#==`.
  (When two temperatures had different scales - automatic conversion was not performed.) (#18).
  - Recticted Rubocop version for Code Climate (#22).
  - Typo `Celsium` instead of `Celcius` (#23).
  - Added Gemfile.lock to .gitignore (#38).

### Docs
  - Added `Active Development Warning` (#19).
  - Badges: Gem Version, Build Status, Maintainability, Coverage Status, License: MIT, Patreon, Inch CI (#14) (#20) (#40).
  - Added docs for all public API (#38).
  - Added usage section in README.md (#38).

### Tech improvements:
  - [Coverals](https://docs.coveralls.io/ruby-on-rails) setup (#10).
  - [SimpleCov](https://github.com/colszowka/simplecov) setup (#10).
  - [Code Climate](https://codeclimate.com/) setup (#13).
  - [ReverseCoverage] setup (#21).
  - [SDoc] setup (#38).
  - [Rerun] setup (#38).
  - Autodeploy of docs to Github Pages (#39).


## 0.2.1
### Features:
  - Spaceship operator <=> (#2).

### Tech improvements:
  - [Byebug](https://github.com/deivid-rodriguez/byebug) setup (#1).
  - [RSpec](https://rspec.info/) setup (#3).
  - [RuboCop](https://github.com/rubocop-hq/rubocop) setup (#5).
  - [Travis CI](https://travis-ci.com/) setup (#4).


## 0.2.0
  - 'Accidentally' yanked.


## 0.1.0
  - Initial Release.

### Features:
  - Creation of `Temperature` using positional arguments.
  - Creation of `Temperature` using keyword arguments.
  - Creation of `Temperature`s from already existing temperature objects (`Temperature#set_degrees`, `Temperature#set_scale`).
  - Conversion to Celsius, Fahrenheit, Kelvin.
  - Dynamic conversion (`Temperature#to_scale`).
  - Equality operator `==`.
  - Addition of `Temperature`s.
  - Subtraction of `Temperature`s.
  - Support of Ruby coersion mechanism.
