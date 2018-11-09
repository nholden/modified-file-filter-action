require "json"
require_relative "push_event"

class ModifiedFileFilter < Struct.new(:raw_event)
  def modified?(file_path)
    push_event.modified_file_paths.include?(file_path)
  end

  private

  def push_event
    PushEvent.new(JSON.parse(raw_event))
  end
end
