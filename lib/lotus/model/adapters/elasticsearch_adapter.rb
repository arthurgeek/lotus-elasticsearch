require "elasticsearch"
require "lotus/model/adapters/abstract"
require "lotus/model/adapters/implementation"
require "lotus/model/adapters/elasticsearch/query"
require "lotus/model/adapters/elasticsearch/command"
require "lotus/model/adapters/elasticsearch/collection"

module Lotus
  module Model
    module Adapters
      class ElasticsearchAdapter < Abstract
        include Implementation

        def initialize(mapper, index, host="localhost:9200")
          super(mapper)

          @client = ::Elasticsearch::Client.new(host: host)
          @index = index

          @collections = {}
        end

        def create(collection, entity)
          entity.id = command(collection).create(entity)
          entity
        end

        def update(collection, entity)
          command(collection).update(entity)
        end

        def delete(collection, entity)
          command(collection).delete(entity)
        end

        def clear(collection)
          command(collection).clear
        end

        def find(collection, id)
          command(collection).get(id)
        end

        def first(collection)
          raise NotImplementedError
        end

        def last(collection)
          raise NotImplementedError
        end

        def command(collection)
          Elasticsearch::Command.new(
            _collection(collection), _mapped_collection(collection)
          )
        end

        def query(collection, context = nil, &blk)
          Elasticsearch::Query.new(
            _collection(collection), _mapped_collection(collection), &blk
          )
        end

        private

        def _collection(name)
          @collections[name] ||= Elasticsearch::Collection.new(
            @client, @index, name, _identity(name)
          )
        end
      end
    end
  end
end
