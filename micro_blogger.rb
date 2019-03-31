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
end
