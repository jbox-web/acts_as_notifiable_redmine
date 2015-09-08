## ![logo](https://raw.github.com/jbox-web/acts_as_notifiable_redmine/gh-pages/images/pusher_logo.png) A gem which makes notifying your Redmine instance easy ;)

[![GitHub license](https://img.shields.io/github/license/jbox-web/active_use_case.svg)](https://github.com/jbox-web/active_use_case/blob/master/LICENSE)
[![Gem](https://img.shields.io/gem/v/acts_as_notifiable_redmine.svg)](https://rubygems.org/gems/acts_as_notifiable_redmine)
[![Gem](https://img.shields.io/gem/dv/acts_as_notifiable_redmine/0.1.1.svg)]()
[![Code Climate](https://codeclimate.com/github/jbox-web/acts_as_notifiable_redmine.png)](https://codeclimate.com/github/jbox-web/acts_as_notifiable_redmine)
[![Dependency Status](https://gemnasium.com/jbox-web/acts_as_notifiable_redmine.svg)](https://gemnasium.com/jbox-web/acts_as_notifiable_redmine)

This gem is designed to integrate the [Pusher Notification System](http://pusher.com) in Redmine but you may use it for other Rails apps ;)

It aims to provide a small DSL for plugin developers who want to use Pusher notifications for their Redmine plugins.

To achieve this, you should install first [Redmine Pusher Notifications](https://github.com/jbox-web/redmine_pusher_notifications) which actually install this gem and the [gritter](https://github.com/RobinBrouwer/gritter) gem.

Then you just need to declare your channels and events in your ```init.rb``` file. That's all!

## Requirements

* Ruby 1.9.x or 2.0.x
* a working [Redmine](http://www.redmine.org/) installation
* a free account on [Pusher](http://pusher.com)
* [pusher](https://github.com/pusher/pusher-gem) gem

## Installation

    gem install acts_as_notifiable_redmine

## Example usage
**(1)** First you need to configure you Pusher account :

    ActsAsNotifiableRedmine::Notifications.register_courier :pusher do
      app_id    'xxxxx'
      key       'xxxxxxxxxxxxxxxxxxxx'
      secret    'xxxxxxxxxxxxxxxxxxxx'
      encrypted true
    end

**Note :** If you're using Redmine Pusher Notifications plugin you don't need to do this. Instead, go to the plugin configuration page.

**(2)** Then you need to register your channels and events : each channel can have many events.
It may also have an optional ```target``` parameter which can be a string or a Proc.

    ActsAsNotifiableRedmine::Notifications.register_channel :channel_test do
      target Proc.new { User.current.login }
      event  :event1, :sticky => true
      event  :event2, :sticky => false
      event  :event3
    end

    ActsAsNotifiableRedmine::Notifications.register_channel :broadcast do
      target 'broadcast'
      event  :event1, :sticky => true
      event  :event2, :sticky => false
      event  :event3
    end

**Note :** If you're using Redmine Pusher Notifications plugin this is done in ```init.rb``` file.

**(3)** Once done, you can get the registered channels and events with :

    ActsAsNotifiableRedmine::Notifications.channels.each do |name, channel|
      puts "#############"
      puts "Channel :"
      puts "name       : #{channel.name}"
      puts "identifier : #{channel.identifier}"
      puts "token      : #{channel.token}"
      puts "events     :"
      channel.events.each do |event|
        puts "  * #{event.name} (sticky : #{event.sticky?})"
      end
      puts ""
    end

To get the Pusher parameters :

    courier = ActsAsNotifiableRedmine::Notifications.courier

    puts "#############"
    puts "Courier :"
    puts "name      : #{courier.name}"
    puts "app_id    : #{courier.app_id}"
    puts "key       : #{courier.key}"
    puts "secret    : #{courier.secret}"
    puts "encrypted : #{courier.encrypted}"

**(4)** Finally to send notifications :

    ActsAsNotifiableRedmine::Notifications.send_notification([channel.token], event.name, {:title => 'Hello!', :message => 'This is a test message !'})

**Note :** The logic to determine wether or not to send a notification is let to the developer. You can easily do this with callbacks :

    class Comment < ActiveRecord::Base
        has_many :watchers
        after_create :send_notification

        private

            def send_notification
                channels = []
                watchers.each do |watcher|
                    token = '<channel_name>-' + watcher.login
                    channels.push(token)
                end
                ActsAsNotifiableRedmine::Notifications.send_notification(channels, <event_name>, {:title => 'Hello!', :message => 'This is a test message !'})
            end
    end

**(5)** And to display them (put this in the layout) :

    <% if User.current.logged? %>

      <%= javascript_tag do %>

        $(document).ready(function() {
          $.extend($.gritter.options, {
            fade_in_speed: 'fast',
            fade_out_speed: 'fast',
            time: 6000,
          });

          $(function() {
            var pusher = new Pusher('<%= ActsAsNotifiableRedmine::Notifications.courier.key %>');

            <% ActsAsNotifiableRedmine::Notifications.channels.each do |name, channel| %>
              var <%= j channel.identifier %> = pusher.subscribe('<%= channel.token %>');

              <%= channel.identifier %>.bind('subscription_error', function(status) {
                $.gritter.add({
                  title: 'Pusher : <%= channel.identifier %>',
                  text: 'Subscription error'
                });
              });

              <% channel.events.each do |event| %>
                <%= channel.identifier %>.bind('<%= event.name %>', function(data) {
                  $.gritter.add({
                    title: data.title,
                    text: data.message,
                    image: data.image,
                    sticky: <%= event.sticky? %>,
                  });
                });

              <% end %>

            <% end %>

          });
        });
      <% end %>
    <% end %>

**Note** : [gritter](https://github.com/RobinBrouwer/gritter) is not bundled with this gem. If you're using [Redmine Pusher Notifications](https://github.com/jbox-web/redmine_pusher_notifications) this part is already done by the plugin.

## Contribute

You can contribute to this plugin in many ways such as :
* Helping with documentation
* Contributing code (features or bugfixes)
* Reporting a bug
* Submitting translations
