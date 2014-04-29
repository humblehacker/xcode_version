require 'xcodeproj'
require 'plist4r'

module XcodeVersion

  class XCProjectTool

    def initialize
      # find an xcode project file in the current directory and open it.
      load_project
      load_info_plists
    end

    def setup
    end

    def stat
      puts "version: #{version_number}"
      puts "build: #{latest_build_number}"
    end

    def bump
      new_build_number = latest_build_number + 1
      update_all_build_numbers new_build_number
    end

    def hotfix
      version_number
    end

    def minor
    end

    def major
    end

    private

    def native_targets
      @project.targets.select { |t| t.instance_of? Xcodeproj::Project::Object::PBXNativeTarget }
    end

    def latest_build_number
      build_numbers = settings_with_name 'CURRENT_PROJECT_VERSION'
      build_numbers.max.to_i
    end

    def update_all_build_numbers(new_build_number)
      update_project_build_numbers(new_build_number)
      update_plist_build_numbers(new_build_number)
    end

    def update_plist_build_numbers(new_build_number)
      @info_plists.each do |pl|
        info = Plist4r.open(pl)
        info['CFBundleVersion'] = new_build_number.to_s
        info.save
      end
    end

    def update_project_build_numbers(new_build_number)
      native_targets.each do |t|
        t.build_configurations.each do |bc|
          bc.build_settings['CURRENT_PROJECT_VERSION'] = new_build_number
        end
      end
      @project.save
    end

    def version_number
      version_numbers = @info_plists.map { |pl| Plist4r.open(pl)['CFBundleShortVersionString'] }.uniq
      raise "Not all version numbers match #{version_numbers}" unless version_numbers.count == 1
      version_numbers.last
    end

    def load_info_plists
      @info_plists = settings_with_name('INFOPLIST_FILE')
    end

    def load_project
      file = Dir.glob('./*.xcodeproj')
      raise "Couldn't find a valid Xcode project in the current directory" if file.empty?
      @project = ::Xcodeproj::Project.open(file.first)
    end

    def settings_with_name(setting_name)
      native_targets.map { |t| t.build_configurations.map { |bc| bc.build_settings[setting_name] } }.flatten.uniq
    end

  end

end