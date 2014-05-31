module ActsAsNotifiableRedmine
  class Event

    attr_reader :name, :sticky
    alias :sticky? :sticky

    def initialize(id, options = {})
      @id     = id.to_sym
      @name   = @id
      @sticky = options[:sticky] || false
    end

  end
end
