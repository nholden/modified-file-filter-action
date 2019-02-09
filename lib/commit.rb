class Commit < Struct.new(:data)
  def modified_file_paths
    data["modified"]
  end

  def message
    data["message"]
  end
end
