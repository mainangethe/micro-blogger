require 'jumpstart_auth'
require 'bitly'

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing.."
    @client = JumpstartAuth.twitter
  end

  def tweet message
    if message.length > 140
      puts "WARNING: Please reenter the message again with less than 140 characters."
    else
      @client.update message
    end
  end

  def dm target, message
    screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }
    if screen_names.include? target
      puts "Trying to send #{ target } this direct message."
      puts message
      tweet_message = "d @#{ target } #{ message }"
      tweet tweet_message
    else
      puts "WARNING: Please resend a dm to people who follow your account."
    end
  end

  def followers_list
    screen_names = []
    @client.followers.collect { |follower| screen_names << @client.user(follower).screen_name }
    screen_names
  end

  def spam_my_followers message
    my_followers = followers_list
    my_followers.each do |follower|
      dm  follower, message
    end
  end

  def everyones_last_tweet
    friends = @client.friends
    friends.each do |friend|
      # find each friend's last message
      last_message = friend.status.source
      # print each friend's screen name
      timestamp = friend.status.created_at
      timestamp.strftime("%A, %b %d")
      puts "At #{ timestamp.strftime("%A, %b %d") }, #{ friend } said..."
      # print each friends last message
      puts "#{ last_message }"
      puts "-------------------------------------------" # separator
    end
  end

  def shorten original_url
    Bitly.use_api_version_3
    bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
    puts "Shortening this URL: #{ original_url }"
    tiny_url = bitly.shorten(original_url).short_url
    puts "This is now your tiny url #{ tiny_url }"
    tiny_url
  end

  def run
    puts "Welcome to Mradi's Twitter Client!"
    command = ""
    while command != "q"
      printf "Enter a command: "
      input = gets.chomp
      parts = input.split(' ')
      command = parts[0]

      case command
      when 'q' then puts "Goodbye! Until next time"
      when 't' then tweet parts[1..-1].join(' ')
      when 'dm' then dm(parts[1], parts[2..-1].join(' '))
      when 'spam' then spam_my_followers parts[1..-1].join(' ')
      when 'elt' then everyones_last_tweet
      when 's' then shorten parts[1]
      else
        puts "Sorry, I don't know how to deal with (#{ command })"
      end
    end
  end
end
#
blogger = MicroBlogger.new
# blogger.followers_list
blogger.run
