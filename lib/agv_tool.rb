module XcodeVersion
  class AGVTool

    def initialize
      val = `agvtool what-version -terse`
      if $? != 0
        raise <<-'END'.gsub(/^ {6}/, "")
      First, in your build settings,
        - set "Versioning System" to "Apple Generic"
        - set "Current Project Version" to 0
        - add "CFBundleShortVersionString" to Info.plist
        END
      end
    end

    def setup
      puts `agvtool new-version -all 1`
      puts `agvtool new-marketing-version 1.0`
      Xcodeproj.read_plist(p1)
    end

    def stat
      puts "Release: #{`agvtool what-marketing-version -terse1`}"
      puts "Build:   #{`agvtool what-version -terse`}"
    end

    def bump
      puts `agvtool bump -all`
    end

    def hotfix
      puts `agvtool bump -all`
      mv = `agvtool what-marketing-version -terse1`.strip
      if mv == ''
        mv = '1.0.1'
      else
        mv = Versionomy.parse(mv).bump(:tiny)
      end
      puts mv
      puts `agvtool new-marketing-version #{mv.to_s}`
    end

    def minor
      puts `agvtool bump -all`
      mv = `agvtool what-marketing-version -terse1`.strip
      if mv == ''
        mv = '1.0'
      else
        mv = Versionomy.parse(mv).bump(:minor).unparse(:optional_fields => [:tiny])
      end
      puts mv
      puts `agvtool new-marketing-version #{mv}`
    end

    def major
      puts `agvtool bump -all`
      mv = `agvtool what-marketing-version -terse1`.strip
      if mv == ''
        mv = '1.0'
      else
        mv = Versionomy.parse(mv).bump(:major).unparse(:optional_fields => [:tiny])
      end
      puts mv
      puts `agvtool new-marketing-version #{mv.to_s}`
    end
  end

end