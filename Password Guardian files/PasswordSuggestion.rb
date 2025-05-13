require 'securerandom'

def strengthen_password(password)
  symbols = %w[! @ # $ % ^ & * _ - + = ?]
  leet_map = {'0'=>'O','1'=>'!','2'=>'@','3'=>'E','4'=>'A','5'=>'S','6'=>'G','7'=>'T','8'=>'B','9'=>'g'}
  strengthened = ''
  symbol_inserted = false

  password.chars.each do |char|
    if char =~ /\d/ && rand < 0.3
      char = leet_map[char] || char
    elsif char =~ /[A-Za-z]/
      char = [char.upcase, char.downcase].sample
    end

    strengthened << char

    base_prob = password =~ /\D/ ? 0.2 : 0.4
    if rand < base_prob
      strengthened << symbols.sample
      symbol_inserted = true
    end
  end

  unless symbol_inserted
    pos = rand(0..strengthened.length)
    strengthened.insert(pos, symbols.sample)
  end

  strengthened
end

def generate_password(length = 16)
  pool = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + %w[! @ # $ % ^ & * _ - + = ?]
  Array.new(length) { pool.sample }.join
end

puts "Welcome to Password Helper!"
puts "Choose an option:"
puts "1) Strengthen an existing password"
puts "2) Generate a new random password"
print "Enter 1 or 2: "
choice = gets.chomp

case choice
when '1'
  print "Enter your current password: "
  current = gets.chomp
  new_pass = strengthen_password(current)
  puts "Your strengthened password is: #{new_pass}"
when '2'
  print "Enter desired password length (default 16): "
  len_input = gets.chomp
  len = len_input.empty? ? 16 : len_input.to_i
  new_pass = generate_password(len)
  puts "Your new password is: #{new_pass}"
else
  puts "Invalid choice. Exiting."
end