module Lotus
  module Model
    module Adapters
      module Elasticsearch
        class Query
          include Enumerable
          extend Forwardable

          def_delegators :all, :each, :to_s, :empty?

          def initialize(dataset, collection, &blk)
            @dataset    = dataset
            @collection = collection
            @options = {}

            instance_eval(&blk) if block_given?
          end

          def all
            @collection.deserialize(run)
          end

          def search(condition)
            key, value = _expand_condition(condition)

            @options[key] = value

            self
          end
          alias_method :where, :search
          alias_method :and, :search

          private

          def run
            @dataset.search(@options)
          end

          def _expand_condition(condition)
            Array(condition).flatten
          end
        end
      end
    end
  end
end
