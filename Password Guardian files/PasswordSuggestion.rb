require 'securerandom'

def strengthen_password(password)
  symbols = %w[! @ # $ % ^ & * _ - + = ?]
  leet_map = {
    '0' => 'O', '1' => '!', '2' => '@', '3' => 'E', '4' => 'A',
    '5' => 'S', '6' => 'G', '7' => 'T', '8' => 'B', '9' => 'g'
  }

  strengthened = ''
  symbol_inserted = false

  password.chars.each do |char|
    # Random leet conversion for digits
    if char =~ /\d/ && rand < 0.3
      char = leet_map[char] || char
    elsif char =~ /[A-Za-z]/
      char = [char.upcase, char.downcase].sample
    end

    strengthened << char

    # Insert symbol occasionally
    base_prob = password =~ /\D/ ? 0.2 : 0.4
    if rand < base_prob
      strengthened << symbols.sample
      symbol_inserted = true
    end
  end

  # Ensure at least one symbol if none inserted
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
