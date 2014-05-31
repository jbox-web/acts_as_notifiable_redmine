module ActsAsNotifiableRedmine
  module Couriers

    def self.factory(klass_name, &block)
      klass = "ActsAsNotifiableRedmine::Couriers::#{klass_name.to_s.capitalize}Courier".constantize
      klass.new(&block)
    rescue => e
      puts e.message
      nil
    end

  end
end
