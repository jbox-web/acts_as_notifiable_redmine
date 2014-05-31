module ActsAsNotifiableRedmine
  module Couriers

    class PusherCourier

      class << self
        def def_field(*names)
          class_eval do
            names.each do |name|
              define_method(name) do |*args|
                args.empty? ? instance_variable_get("@#{name}") : instance_variable_set("@#{name}", *args)
              end
            end
          end
        end
      end

      def_field :name, :app_id, :key, :secret, :encrypted


      def initialize(&block)
        @name      = 'Pusher'
        @app_id    = ''
        @key       = ''
        @secret    = ''
        @encrypted = true

        instance_eval(&block)
        setup_pusher
      end


      def send_notification(channels, event, options)
        Pusher.trigger(channels, event, options)
      end


      private


      def setup_pusher
        Pusher.app_id    = @app_id
        Pusher.key       = @key
        Pusher.secret    = @secret
        Pusher.encrypted = @encrypted
      end

    end

  end
end
