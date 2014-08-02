require "elasticsearch"
require "lotus/model/adapters/abstract"
require "lotus/model/adapters/implementation"
require "lotus/model/adapters/elasticsearch/command"
require "lotus/model/adapters/elasticsearch/collection"

module Lotus
  module Model
    module Adapters
      class ElasticsearchAdapter < Abstract
        include Implementation

        def initialize(mapper, host)
          super

          @client = ::Elasticsearch::Client.new(host: host)

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

        private

        def _collection(name)
          @collections[name] ||= Elasticsearch::Collection.new(
            @client, name, _identity(name)
          )
        end
      end
    end
  end
end
