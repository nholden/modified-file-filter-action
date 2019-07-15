require_relative "commit"
require "json"

class PushEvent
  # https://developer.github.com/v3/activity/events/types/#pushevent
  REQUIRED_PUSH_EVENT_KEYS = %w(ref commits)

  attr_reader :data

  def initialize(raw_event)
    @data = JSON.parse(raw_event)
  end

  def valid?
    REQUIRED_PUSH_EVENT_KEYS.all? { |required_key| data.keys.include?(required_key) }
  end

  def modified_files(*patterns)
    modified_file_paths.select{ |file_path| patterns.select{ |pattern| File.fnmatch(pattern, file_path) }.any? }
  end

  private

  def modified_file_paths
    @modified_file_paths ||= if pull_request_merge?
      head_commit.modified_file_paths
    else
      commits.map(&:modified_file_paths).flatten.compact.uniq
    end
  end

  def pull_request_merge?
    return false if head_commit.nil?
    head_commit.message.match?(/Merge pull request/)
  end

  def head_commit
    @head_commit ||= if data["head_commit"].nil?
      nil
    else
      Commit.new(data["head_commit"])
    end
  end

  def commits
    @commits ||= if data["commits"].nil?
      []
    else
      data["commits"].map { |commit_data| Commit.new(commit_data) }
    end
  end
end
