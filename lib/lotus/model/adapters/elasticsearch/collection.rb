require "securerandom"
require "lotus/utils/hash"

module Lotus
  module Model
    module Adapters
      module Elasticsearch
        class Collection
          def initialize(client, index, name, identity)
            @client, @index, @name, @identity = client, index, name, identity
          end

          def create(entity)
            id = entity[@identity] = SecureRandom.uuid

            _index(id, entity)

            id
          end

          def update(entity)
            _index(entity[@identity], entity)
          end

          def delete(entity)
            @client.delete(
              index: @index,
              type: @name,
              id: entity.id
            )
          end

          def clear
            @client.indices.delete_mapping(
              index: @index,
              type: @name
            )
          end

          def search(query)
            response = @client.search(
              index: @index,
              type: @name,
              body: { query: _build_query(query) }
            )

            _deserialize_response(response)
          end

          private

          def _index(id, entity)
            @client.index(
              index: @index,
              type: @name,
              id: id,
              body: entity
            )
          end

          def _deserialize_response(response)
            response["hits"]["hits"].map { |item| _deserialize_item(item) }
          end

          def _deserialize_item(item)
            Lotus::Utils::Hash.new(item["_source"]).symbolize!
          end

          def _build_query(query)
            if query.empty?
              { match_all: {}}
            else
              { match: query }
            end
          end
        end
      end
    end
  end
end
