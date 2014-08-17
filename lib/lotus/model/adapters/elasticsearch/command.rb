module Lotus
  module Model
    module Adapters
      module Elasticsearch
        class Command
          def initialize(dataset, collection)
            @dataset, @collection = dataset, collection
          end

          def create(entity)
            @dataset.create(
              _serialize(entity)
            )
          end

          def update(entity)
            @dataset.update(
              _serialize(entity)
            )
          end

          def delete(entity)
            @dataset.delete(entity)
          end

          def clear
            @dataset.clear
          end

          def get(id)
            _deserialize([@dataset.get(id)].compact).first
          end

          private

          def _serialize(entity)
            @collection.serialize(entity)
          end

          def _deserialize(records)
            @collection.deserialize(records)
          end
        end
      end
    end
  end
end
