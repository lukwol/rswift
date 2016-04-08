module Xcodeproj
  class Project
    module Object
      class PBXGroup

        def file_for_path(path)
          result_file = files.find do |file|
            file.path == path
          end
          result_file = new_file(path) unless result_file
          result_file
        end

        def group_for_path(path)
          result_group = groups.find do |group|
            group.path == path
          end
          result_group = new_group(path, path) unless result_group
          result_group
        end
      end
    end
  end
end
