require 'jumpstart_auth'

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
      else
        puts "Sorry, I don't know how to deal with (#{ command })"
      end
    end
  end
end

blogger = MicroBlogger.new
blogger.followers_list
blogger.run
