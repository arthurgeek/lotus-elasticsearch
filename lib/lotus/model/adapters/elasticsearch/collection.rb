require "securerandom"

module Lotus
  module Model
    module Adapters
      module Elasticsearch
        class Collection
          def initialize(client, name, identity)
            @client, @name, @identity = client, name, identity
          end

          def create(entity)
            id = entity[@identity] = SecureRandom.uuid

            _index(id, entity)

            id
          end

          def update(entity)
            _index(entity[:uuid], entity)
          end

          def delete(entity)
            @client.delete(
              index: "index_name",
              type: @name,
              id: entity.id
            )
          end

          def clear
            @client.indices.delete_mapping(
              index: "index_name",
              type: @name
            )
          end

          private

          def _index(id, entity)
            @client.index(
              index: "index_name",
              type: @name,
              id: id,
              body: entity
            )
          end
        end
      end
    end
  end
end
