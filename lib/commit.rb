class Commit < Struct.new(:data)
  def modified_file_paths
    data["modified"]
  end
end
