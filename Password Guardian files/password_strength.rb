# This function takes in a string.
# The function will then return a score and entropy value 
# based on how good the password is. Answer is in [score, pattern]
# Max score is 70.

def password_strength(password)
  score = 0
  charset_size = 0
  
  # Scoring based on length
  pass_length = password.length
  if pass_length < 8
    score += 0
  elsif pass_length <= 10
    score += 10
  elsif pass_length <= 14
    score += 25
  else
    score += 40
  end

  
  # Scoring based on diversity
  if password =~ /[a-z]/ # Check for Lowercase
    score += 5
    charset_size += 26
  end
  if password =~ /[A-Z]/ # Check for Uppercase
    score += 5
    charset_size += 26
  end
  if password =~ /[\d]/ # Check for Digits
    score += 10
    charset_size += 10
  end
  if password =~ /[^a-zA-Z\d]/ # Check for Symbols
    score += 10
    charset_size += 32
  end


  # Penalize for repetition
  repeats = password.scan(/(.)\1{2,}/) # for ex: 111, !!!, aaaa
  score -= repeats.length * 5
  
  patterns = password.scan(/(..+)\1+/) # for ex: 123123, abab
  score -= patterns.length * 5
  
  
  # Calculate entropy
  entropy = Math.log2(charset_size) * password.length if charset_size > 0

  return [score, entropy]
end
