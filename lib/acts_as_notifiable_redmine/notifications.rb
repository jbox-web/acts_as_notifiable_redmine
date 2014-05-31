module ActsAsNotifiableRedmine
  class Notifications

    @@channels = {}
    @@courier  = nil

    class << self

      def register_courier(type, &block)
        @@courier = Couriers.factory(type, &block)
      end


      def register_channel(id, &block)
        @@channels[id] = Channel.new(id, &block)
      end


      def channels
        @@channels
      end


      def courier
        @@courier
      end


      def find_by_id(id)
        @@channels[id.to_sym]
      end


      def send_notification(channels, event, options)
        @@courier.send_notification(channels, event, options)
      end

    end

  end
end
