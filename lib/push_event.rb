require_relative "commit"

class PushEvent < Struct.new(:data)
  def modified_file_paths
    commits.map(&:modified_file_paths).flatten.compact.uniq
  end

  private

  def commits
    return [] if data["commits"].nil?
    data["commits"].map { |commit_data| Commit.new(commit_data) }
  end
end
