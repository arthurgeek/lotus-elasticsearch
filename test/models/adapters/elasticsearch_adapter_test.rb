require "test_helper"

describe Lotus::Model::Adapters::ElasticsearchAdapter do
  before do
    TestUser = Struct.new(:id, :name, :age) do
      include Lotus::Entity
    end

    TestDevice = Struct.new(:id) do
      include Lotus::Entity
    end

    @mapper = Lotus::Model::Mapper.new do
      collection :users do
        entity TestUser

        attribute :id, String
        attribute :name, String
        attribute :age, Integer
      end

      collection :devices do
        entity TestDevice

        attribute :id, String
      end
    end.load!

    @adapter = Lotus::Model::Adapters::ElasticsearchAdapter.new(
      @mapper, ELASTICSEARCH_INDEX, ELASTICSEARCH_HOST
    )
    @adapter.clear(collection)
  end

  after do
    Object.send(:remove_const, :TestUser)
    Object.send(:remove_const, :TestDevice)
  end

  let(:collection) { :users }

  describe "multiple collections" do
    it "create records" do
      user = TestUser.new
      device = TestDevice.new

      @adapter.create(:users, user)
      @adapter.create(:devices, device)

      @adapter.all(:users).must_equal   [user]
      @adapter.all(:devices).must_equal [device]
    end
  end

  describe "#first" do
    it "raises an error" do
      -> { @adapter.first(collection) }.must_raise NotImplementedError
    end
  end

  describe "#last" do
    it "raises an error" do
      -> { @adapter.last(collection) }.must_raise NotImplementedError
    end
  end

  describe "#persist" do
    describe "when the given entity is not persisted" do
      let(:entity) { TestUser.new }

      it "stores the record and assigns an id" do
        @adapter.persist(collection, entity)

        entity.id.wont_be_nil

        @adapter.find(collection, entity.id).must_equal entity
      end
    end

    describe "when the given entity is persisted" do
      before do
        @adapter.create(collection, entity)
      end

      let(:entity) { TestUser.new }

      it "updates the record and leaves untouched the id" do
        id = entity.id
        id.wont_be_nil

        entity.name = "L"
        @adapter.persist(collection, entity)

        entity.id.must_equal(id)
        @adapter.find(collection, entity.id).name.must_equal entity.name
      end
    end
  end

  describe "#create" do
    let(:entity) { TestUser.new }

    it "stores the record and assigns an id" do
      @adapter.create(collection, entity)

      entity.id.wont_be_nil
      @adapter.find(collection, entity.id).must_equal entity
    end
  end

  describe "#update" do
    before do
      @adapter.create(collection, entity)
    end

    let(:entity) { TestUser.new(id: nil, name: "L") }

    it "stores the changes and leave the id untouched" do
      id = entity.id

      entity.name = "MG"
      @adapter.update(collection, entity)

      entity.id.must_equal id
      @adapter.find(collection, entity.id).name.must_equal entity.name
    end
  end

  describe "#delete" do
    before do
      @adapter.create(collection, entity)
    end

    let(:entity) { TestUser.new }

    it "removes the given identity" do
      @adapter.delete(collection, entity)
      @adapter.find(collection, entity.id).must_be_nil
    end
  end

  describe "#all" do
    describe "when no records are persisted" do
      before do
        @adapter.clear(collection)
      end

      it "returns an empty collection" do
        @adapter.all(collection).must_be_empty
      end
    end

    describe "when some records are persisted" do
      before do
        @adapter.create(collection, entity)
      end

      let(:entity) { TestUser.new }

      it "returns all of them" do
        @adapter.all(collection).must_equal [entity]
      end
    end
  end

  describe "#find" do
    before do
      @adapter.create(collection, entity)
    end

    let(:entity) { TestUser.new }

    it "returns the record by id" do
      @adapter.find(collection, entity.id).must_equal entity
    end

    it "returns nil when the record cannot be found" do
      @adapter.find(collection, 1_000_000).must_be_nil
    end

    it "returns nil when the given id is nil" do
      @adapter.find(collection, nil).must_be_nil
    end
  end

  describe "#clear" do
    before do
      @adapter.create(collection, entity)
    end

    let(:entity) { TestUser.new }

    it "removes all the records" do
      @adapter.clear(collection)
      @adapter.all(collection).must_be_empty
    end
  end

  describe '#query' do
    before do
      @adapter.clear(collection)
    end

    let(:user1) { TestUser.new(name: 'L',  age: '32') }
    let(:user2) { TestUser.new(name: 'MG', age: 31) }

    describe "where" do
      describe "with an empty collection" do
        it "returns an empty result set" do
          result = @adapter.query(collection) do
            where(id: 23)
          end.all

          result.must_be_empty
        end
      end

      describe "with a filled collection" do
        before do
          @adapter.create(collection, user1)
          @adapter.create(collection, user2)
        end

        it "returns selected records" do
          id = user1.id

          query = Proc.new {
            where(id: id)
          }

          result = @adapter.query(collection, &query).all
          result.must_equal [user1]
        end

        it "can use multiple where conditions" do
          id   = user1.id
          name = user1.name

          query = Proc.new {
            where(id: id).where(name: name)
          }

          result = @adapter.query(collection, &query).all
          result.must_equal [user1]
        end

        it "can use multiple where conditions with 'and' alias" do
          id   = user1.id
          name = user1.name

          query = Proc.new {
            where(id: id).and(name: name)
          }

          result = @adapter.query(collection, &query).all
          result.must_equal [user1]
        end
      end
    end
  end
end
