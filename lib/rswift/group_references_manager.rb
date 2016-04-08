module RSwift
  class GroupReferencesManager

    attr_accessor :files_references_manager

    def initialize(files_references_manager)
      @files_references_manager = files_references_manager
    end

    def update_files_references(group, target)
      compile_sources_extensions = RSwift::Constants::COMPILE_SOURCES_EXTENSIONS
      resources_extensions = RSwift::Constants::RESOURCES_EXTENSIONS

      entries = Dir.glob("#{group.real_path.to_path}/*")
      file_entries = entries.select { |entry| File.file? entry }

      file_entries.each do |entry|
        basename = File.basename entry
        extname = File.extname entry
        file_reference = group.file_for_path(basename)
        if basename == 'Info.plist' || extname == '.xcdatamodel'
          next
        elsif compile_sources_extensions.include? extname
          target.source_build_phase.add_file_reference(file_reference, true)
        elsif resources_extensions.include? extname
          target.resources_build_phase.add_file_reference(file_reference, true)
        end
      end
    end

    def update_directory_references(group, target)
      compile_sources_extensions = RSwift::Constants::COMPILE_SOURCES_EXTENSIONS
      resources_extensions = RSwift::Constants::RESOURCES_EXTENSIONS

      entries = Dir.glob("#{group.real_path.to_path}/*")
      directory_entries = entries.select { |entry| !File.file? entry }

      directory_entries.each do |entry|
        basename = File.basename entry
        extname = File.extname entry
        if compile_sources_extensions.include? extname
          if extname != '.xcdatamodeld'
            file_reference = group.file_for_path(basename)
            target.source_build_phase.add_file_reference(file_reference, true)
          else
            add_xcdatamodel(entry, group, target)
          end
        elsif resources_extensions.include? extname
          file_reference = group.file_for_path(basename)
          target.resources_build_phase.add_file_reference(file_reference, true)
        else
          group_reference = group.group_for_path(basename)
          @files_references_manager.update_target_references(group_reference, target)
        end
      end
    end

    def cleanup_invalid_references(group)
      compile_sources_extensions = RSwift::Constants::COMPILE_SOURCES_EXTENSIONS
      resources_extensions = RSwift::Constants::RESOURCES_EXTENSIONS

      invalid_files_refs = group.files
      invalid_groups_refs = group.groups

      entries = Dir.glob("#{group.real_path.to_path}/*")
      entries.each do |entry|
        basename = File.basename entry
        extname = File.extname entry

        if compile_sources_extensions.include? extname
          file_ref = invalid_files_refs.find { |invalid_file_ref| invalid_file_ref.path == basename }
          invalid_files_refs.delete(file_ref)
        elsif resources_extensions.include? extname
          file_ref = invalid_files_refs.find { |invalid_file_ref| invalid_file_ref.path == basename }
          invalid_files_refs.delete(file_ref)
        elsif File.file? entry
          file_ref = invalid_files_refs.find { |invalid_file_ref| invalid_file_ref.path == basename }
          invalid_files_refs.delete(file_ref)
        else
          group_ref = invalid_groups_refs.find { |invalid_group_ref| invalid_group_ref.path == basename }
          invalid_groups_refs.delete(group_ref)
        end
      end

      invalid_files_refs.each { |file_ref| file_ref.remove_from_project }
      invalid_groups_refs.each do |group_ref|
        group_ref.clear
        group_ref.remove_from_project
      end
    end

    def cleanup_build_files(target)
      invalid_build_sources = target.source_build_phase.files.select { |file| file.file_ref == nil }
      invalid_build_sources.each { |file| target.source_build_phase.remove_build_file(file) }

      invalid_resources = target.resources_build_phase.files.select { |file| file.file_ref == nil }
      invalid_resources.each { |file| target.resources_build_phase.remove_build_file(file) }
    end

    private

    def add_xcdatamodel(entry, group, target)
      basename = File.basename entry
      extname = File.extname entry
      version_group = group.version_groups.find { |version_group| version_group.path == basename }
      if version_group == nil
        file_reference = group.file_for_path(basename)
        target.source_build_phase.add_file_reference(file_reference, true)
        version_group = group.version_groups.find { |version_group| version_group.path == basename }
        @files_references_manager.update_target_references(version_group, target)
      end
    end
  end
end
