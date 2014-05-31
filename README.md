### A gem which makes notifying your Redmine instance easy ;)

This gem is designed to integrate the [Pusher Notification System](http://pusher.com) in Redmine.

It must be used with [Redmine Pusher Notifications](https://github.com/jbox-web/redmine_pusher_notifications).

## Code status

* [![Gem Version](https://badge.fury.io/rb/acts_as_notifiable_redmine.svg)](http://badge.fury.io/rb/acts_as_notifiable_redmine)
* [![Code Climate](https://codeclimate.com/github/jbox-web/acts_as_notifiable_redmine.png)](https://codeclimate.com/github/jbox-web/acts_as_notifiable_redmine)

## Requirements
* Ruby 1.9.x or 2.0.x
* a working [Redmine](http://www.redmine.org/) installation
* an account on [Pusher](http://pusher.com)

## Installation

    gem install acts_as_notifiable_redmine

## Example usage
First you need to configure you Pusher account :

    ActsAsNotifiableRedmine::Notifications.register_courier :pusher do
      app_id    'xxxxx'
      key       'xxxxxxxxxxxxxxxxxxxx'
      secret    'xxxxxxxxxxxxxxxxxxxx'
      encrypted true
    end

Then you need to register your channels and events :

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

Once done, you can get the registered channels and events with :

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
    
Finally to send notifications :

    ActsAsNotifiableRedmine::Notifications.send_notification(channels, event, {:message => 'hello!'})
  
## Copyrights & License
acts_as_notifiable_redmine is completely free and open source and released under the [MIT License](https://github.com/jbox-web/acts_as_notifiable_redmine/blob/devel/LICENSE.txt).

Copyright (c) 2014 Nicolas Rodriguez (nrodriguez@jbox-web.com), JBox Web (http://www.jbox-web.com) [![endorse](https://api.coderwall.com/n-rodriguez/endorsecount.png)](https://coderwall.com/n-rodriguez)

## Contribute

You can contribute to this plugin in many ways such as :
* Helping with documentation
* Contributing code (features or bugfixes)
* Reporting a bug
* Submitting translations

You can also donate :)

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=FBT7E7DAVVEEU)
