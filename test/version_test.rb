require "test_helper"

describe Lotus::Elasticsearch::VERSION do
  it "returns current version" do
    Lotus::Elasticsearch::VERSION.must_equal "0.0.1"
  end
end
