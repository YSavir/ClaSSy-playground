module Classy
  module Property

    def self.propertize(string)
      string.split('-').map(&:capitalize).join
    end

    def self.new_of_type(property_type, selector)
      prop_name = propertize(property_type)
      constant = get_property_constant prop_name
      constant.new(selector)
    end

    def self.get_property_constant(name)
      constantize "Classy::Property::#{name}"
    end
  end 
end
