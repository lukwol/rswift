module RSwift
  class TemplateManager
    include Thor::Base
    include Thor::Actions

    attr_reader :name

    def self.source_root
      File.dirname(__FILE__)
    end

    def create_files_for_template(name, template)
      @name = name
      current_directory_path = File.dirname(__FILE__)
      template_directory = File.join(current_directory_path, 'templates/app', template.to_s)
      Dir.glob("#{template_directory}/**/*.erb", File::FNM_DOTMATCH).each do |template_path|
        relative_template_path = template_path.sub(current_directory_path + '/', '')

        relative_erb_file_path = template_path.sub(template_directory, '')
        file_name = File.basename(relative_erb_file_path, '.erb')
        relative_directory_path = File.dirname(relative_erb_file_path)
        relative_file_path = File.join(name, relative_directory_path, file_name)

        template relative_template_path, relative_file_path
      end
    end
  end
end
