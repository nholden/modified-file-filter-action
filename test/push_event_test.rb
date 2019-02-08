require "minitest/autorun"
require_relative "../lib/push_event"

class PushEventTest < Minitest::Test
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

    @push_event = PushEvent.new(event_string)
  end

  def test_modified_file_paths
    assert @push_event.modified?("app/models/user.rb")
    assert @push_event.modified?("app/models/order.rb")
    refute @push_event.modified?("app/models/action.rb")
  end

  def test_valid_event
    assert_predicate @push_event, :valid?
  end

  def test_pull_request_event
    pull_request_event_string = <<-JSON
      {
        "action": "closed",
        "number": 1,
        "pull_request": {},
        "changes": {}
      }
    JSON

    invalid_event = PushEvent.new(pull_request_event_string)

    refute_predicate invalid_event, :valid?
  end
end
