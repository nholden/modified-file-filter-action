require "test_helper"
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
    assert @push_event.modified_files("app/models/user.rb").any?
    assert @push_event.modified_files("app/models/order.rb").any?
    refute @push_event.modified_files("app/models/action.rb").any?
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

  def test_considers_only_head_commit_when_merging_pull_request
    event_string = <<-JSON
      {
        "ref": "refs/heads/another-branch",
        "head_commit": {
          "message": "Merge pull request #1",
          "modified": [
            "app/models/user.rb"
          ]
        },
        "commits": [
          {
            "message": "Merge pull request #1",
            "modified": [
              "app/models/user.rb"
            ]
          },
          {
            "message": "Revert changes to order",
            "modified": [
              "app/models/order.rb"
            ]
          },
          {
            "message": "Make some changes",
            "modified": [
              "app/models/user.rb",
              "app/models/order.rb"
            ]
          }
        ]
      }
    JSON

    push_event = PushEvent.new(event_string)

    assert push_event.modified_files("app/models/user.rb").any?
    refute push_event.modified_files("app/models/order.rb").any?
    refute @push_event.modified_files("app/models/action.rb").any?
  end

  def test_considers_all_commits_when_not_merging_pull_request
    event_string = <<-JSON
      {
        "ref": "refs/heads/another-branch",
        "head_commit": {
          "message": "Make some other changes",
          "modified": [
            "app/models/user.rb"
          ]
        },
        "commits": [
          {
            "message": "Make some other changes",
            "modified": [
              "app/models/user.rb"
            ]
          },
          {
            "message": "Revert changes to order",
            "modified": [
              "app/models/order.rb"
            ]
          },
          {
            "message": "Make some changes",
            "modified": [
              "app/models/user.rb",
              "app/models/order.rb"
            ]
          }
        ]
      }
    JSON

    push_event = PushEvent.new(event_string)

    assert push_event.modified_files("app/models/user.rb").any?
    assert push_event.modified_files("app/models/order.rb").any?
    refute @push_event.modified_files("app/models/action.rb").any?
  end

  def test_glob_pattern
    assert @push_event.modified_files("app/models/*").any?
    assert @push_event.modified_files("**").any?
    refute @push_event.modified_files("app/other/*").any?
  end

  def test_multiple_file_paths
    assert @push_event.modified_files("app/models/user.rb", "app/models/order.rb").any?
    assert @push_event.modified_files("app/models/user.rb", "app/models/action.rb").any?
    refute @push_event.modified_files("app/models/action.rb", "app/models/other.rb").any?
  end

end
