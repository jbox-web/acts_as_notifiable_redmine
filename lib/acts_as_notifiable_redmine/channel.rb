module ActsAsNotifiableRedmine
  class Channel

    attr_reader :name, :identifier, :events

    def initialize(id, &block)
      @id         = id.to_sym
      @name       = @id
      @identifier = "channel_#{name}"
      @events     = []
      @target     = "#{name}"

      instance_eval(&block)
    end


    def target(target)
      @target = target
    end


    def token
      if @target.is_a?(Proc)
        "#{@name}-#{@target.call(self)}"
      else
        @target
      end
    end


    def event(name, options = {})
      new_event = Event.new(name, options)
      @events.push(new_event)
    end

  end
end
