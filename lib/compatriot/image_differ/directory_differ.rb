require_relative 'color_differ'

module Compatriot
  # Used to diff images with the same name in directory1 and directory2
  class DirectoryDiffer

    def initialize(directory1, directory2, results_directory = './results')
      @directory1        = directory1
      @directory2        = directory2
      @results_directory = results_directory
    end

    def compute!
      files_to_diff = Dir[@directory1 + '/*']
      files_to_diff.each do |file|
        basename = File.basename(file)
        file1 = File.absolute_path(file)
        file2 = File.absolute_path(@directory2 + '/' + basename)
        Compatriot::ColorDiffer.diff(file1, file2, @results_directory)
      end
    end
  end
end
