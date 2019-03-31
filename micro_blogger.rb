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
      else
        puts "Sorry, I don't know how to deal with (#{ command })"
      end
    end
  end
end

blogger = MicroBlogger.new
blogger.run
