require "minitest/autorun"
require_relative "../lib/modified_file_filter"

class ModifiedFileFilterTest < Minitest::Test
  def setup
    event_string = <<-JSON
      {
        "ref": "refs/heads/another-branch",
        "commits": [
          {
            "modified": [
              "app/models/user.rb"
            ]
          },
          {
            "modified": [
              "app/models/order.rb"
            ]
          }
        ]
      }
    JSON

    @filter = ModifiedFileFilter.new(event_string)
  end

  def test_modified_file_paths
    assert @filter.modified?("app/models/user.rb")
    assert @filter.modified?("app/models/order.rb")
    refute @filter.modified?("app/models/action.rb")
  end
end
