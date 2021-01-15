require 'toml-rb'

module CfnToml
  def self.key toml_filepath, key
    data = TomlRB.load_file(toml_filepath)
    namespace, key = key.split('.')
    data[namespace][key]
  end

  def self.params toml_filepath, params_version
    data = TomlRB.load_file(toml_filepath)
    if params_version == 'v1'
      data['parameters'].map do |k,v|
        "ParameterKey=#{k},ParameterValue=#{v}"
      end.join(' ')
    elsif params_version == 'v2'
      data['parameters'].map do |k,v|
        "#{k}=#{v}"
      end.join(' ')
    end
  end
end
