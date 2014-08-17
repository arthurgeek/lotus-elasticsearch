# Lotus::Model Elasticsearch Adapter

This adapter implements persistence layer for Elasticsearch.

It is built using `Elasticsearch::Client`, which is part of `elasticsearch` gem.

This is a POC, not production-ready. Work still in progress.

## Status

[![Build Status](https://secure.travis-ci.org/arthurgeek/lotus-elasticsearch.svg?branch=master)](http://travis-ci.org/arthurgeek/lotus-elasticsearch?branch=master)
[![Coverage Status](https://img.shields.io/coveralls/arthurgeek/lotus-elasticsearch.svg)](https://coveralls.io/r/arthurgeek/lotus-elasticsearch)
[![Code Climate](https://codeclimate.com/github/arthurgeek/lotus-elasticsearch/badges/gpa.svg)](https://codeclimate.com/github/arthurgeek/lotus-elasticsearch)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lotus-elasticsearch'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lotus-elasticsearch

## Usage

Please refer to Lotus::Model docs for any details related to Entity, Repository,
Data Mapper and Adapter.

## Contributing

1. Fork it ( https://github.com/arthurgeek/lotus-elasticsearch/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
