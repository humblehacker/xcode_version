require 'xcode_version/version'
require 'agv_tool'
require 'xc_project_tool'

module XcodeVersion

  def self.setup
    @tool.setup
  end

  def self.stat
    @tool.stat
  end

  def self.bump
    @tool.bump
  end

  def self.hotfix
    @tool.hotfix
  end

  def self.minor
    @tool.minor
  end

  def self.major
    @tool.major
  end

  def self.use_agvtool= use_agvtool
    if use_agvtool
      @tool = AGVTool.new
    else
      @tool = XCProjectTool.new
    end
  end

end
