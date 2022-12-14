require 'json'

class JsonScaffold

  def self.load_json(file_name)
    file_contents = File.read(file_name)
    return JSON.parse(file_contents)
  end

  def self.analyze_value(key, value)
    if key.downcase.include?("date")
      return "date"
    elsif value.class == NilClass
      return "string"
    elsif (value.class == String) and (value.length > 256)
      return "text"
    else
      return value.class.to_s.downcase
    end
  end


  def self.gen_scaffold(model_name, json_data)
      scaffold_str = "rails g scaffold " + model_name
      json_data.each do |key, value|
        scaffold_str += " " + key + ":" + analyze_value(key, value)
      end
      return scaffold_str
  end


  def self.gen(model_name, file_name)
    json_data = load_json(file_name)
    puts gen_scaffold(model_name, json_data)
  end

end

# sample invocation
JsonScaffold.gen("Patent", "sample.json")