require 'xcode_version/version'
require 'versionomy'

module XcodeVersion

  def self.setup
    puts `agvtool new-version -all 1`
    puts `agvtool new-marketing-version 1.0`
  end

  def self.stat
    puts "Release: #{`agvtool what-marketing-version -terse1`}"
    puts "Build:   #{`agvtool what-version -terse`}"
  end

  def self.what_version
    `agvtool what-version -terse`
  end

  def self.bump
    puts `agvtool bump -all`
  end

  def self.hotfix
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

  def self.minor
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

  def self.major
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
