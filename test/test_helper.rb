require "bundler/setup"

if ENV["COVERAGE"] == "true"
  require "simplecov"
  require "coveralls"

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]

  SimpleCov.start do
    command_name "test"
    add_filter   "test"
  end
end

# Register `at_exit` handler for integration tests shutdown.
# MUST be called before requiring `test/unit`/`minitest`.
at_exit { Lotus::Elasticsearch::TestCase.__run_at_exit_hooks }

require "minitest/autorun"
require "turn"
require "elasticsearch/extensions/test/cluster"
require "elasticsearch/extensions/test/startup_shutdown"

require "lotus-elasticsearch"

ELASTICSEARCH_HOST = "localhost:9250"
ELASTICSEARCH_INDEX = "test"

module Lotus
  module Elasticsearch
    module TestCase
      extend ::Elasticsearch::Extensions::Test::StartupShutdown

      startup  { ::Elasticsearch::Extensions::Test::Cluster.start(nodes: 1) unless ::Elasticsearch::Extensions::Test::Cluster.running? }
      shutdown { ::Elasticsearch::Extensions::Test::Cluster.stop if started? }

      def before_setup
        @client = ::Elasticsearch::Client.new host: ELASTICSEARCH_HOST
        @client.indices.create index: ELASTICSEARCH_INDEX
      end

      def after_teardown
        @client.indices.delete index: ELASTICSEARCH_INDEX
      end
    end
  end
end

class MiniTest::Unit::TestCase
  include Lotus::Elasticsearch::TestCase
end
