# This function takes in a string.
# The function will then return a positive integer
# Number is based on how many breaches contain the password
require 'digest'
require 'httparty'
class Breach_Checker
  include HTTParty
  base_uri "https://api.pwnedpasswords.com/range/"
  def check(password)

    #hash the given password
    hashed_password = Digest::SHA1.hexdigest(password).upcase
    prefix = hashed_password[0..4]
    suffix = hashed_password[5..-1]

    #wraps everything in a try(begin) and catch(rescue) box
    begin
      #obtain results from http request using the 1st 5 characters of hashed password
      query = self.class.get("/#{prefix}")

      unless query.success?
        warn "API request failed with status #{query.code}"
        return nil
      end

      query.body.each_line do |line|
        hash_suffix, count = line.strip.split(':')
        return count.to_i if hash_suffix == suffix
      end

      0     #if the code works but doesn't return any result up until this point Ruby defaults to return this 0
    rescue SocketError => e
      warn "Network error: #{e.message}"
      nil     #if the code block runs up to this point Ruby defaults to return this nil after giving a warning
    rescue HTTParty::Error => e
      warn "HTTParty error: #{e.message}"
      nil
    rescue StandardError => e
      warn "Unexpected error: #{e.class} - #{e.message}"
      nil
    end
  end
end