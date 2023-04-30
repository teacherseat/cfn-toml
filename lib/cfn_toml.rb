require 'toml-rb'
require 'fileutils'
require 'yaml'

module CfnToml
  def self.init toml_filepath, cfn_filepath, stackname, profile
    region = `aws configure get region --profile #{profile}`
    region = 'us-east-1' if region.nil? || region == ''
    stackname ||= 'stackname'

    toml_path = File.dirname toml_filepath
    FileUtils.mkpath(toml_path) unless File.exist?(toml_path)

    File.open(toml_filepath, "w") do |f| 
      f.write "[deploy]\n"
      f.write "profile = '#{profile}'\n"
      f.write "stack_name = '#{stackname}'\n"
      f.write "region = '#{region.chomp}'\n\n"
      f.write "[parameters]\n"
      self.init_parameters f, cfn_filepath
    end
  end

  def self.init_parameters f, cfn_filepath
    return unless File.exist?(cfn_filepath)
    contents = File.open(cfn_filepath).read
    hash = YAML.load(contents)
    return unless hash.key?('Parameters')

    hash['Parameters'].each do |name, values|
      if values.key?('Description')
        lines = values['Description'].split("\n")
        lines.each do |line|
          f.write "# #{line} \n"
        end
      end
      if values.key?('Default')
        f.write "##{name} = '#{values['Default']}' # #{values['Type']}\n"
      else
        f.write "#{name} = '' # #{values['Type']}\n"
      end
    end
  end

  def self.key toml_filepath, key
    data = TomlRB.load_file(toml_filepath)
    namespace, key = key.split('.')
    data[namespace][key]
  end

  def self.params toml_filepath, params_version, parameters_name='parameters'
    data = TomlRB.load_file(toml_filepath)
    parameters_name ||= 'parameters'
    if params_version == 'v1'
      data[parameters_name].map do |k,v|
        "ParameterKey=#{k},ParameterValue=#{v}"
      end.join(' ')
    elsif params_version == 'v2'
      data[parameters_name].map do |k,v|
        "#{k}=#{v}"
      end.join(' ')
    end
  end
end
