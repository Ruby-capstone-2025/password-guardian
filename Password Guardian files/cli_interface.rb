require 'bundler/setup'           # load gems from Gemfile
require 'tty-prompt'              # for prompting input
require 'tty-spinner'             # for spinner animations
require 'pastel'                  # for colored output

require_relative 'password_strength'   # defines top-level method password_strength(password)
require_relative 'PasswordSuggestion'  # defines top-level methods strengthen_password(password), generate_password(length)
require_relative 'breach_checker'      # defines class BreachChecker#check_breach(password)

class PasswordCLI
  def initialize
    @prompt = TTY::Prompt.new
    @pastel = Pastel.new
  end

  def start
    loop do
      puts @pastel.green("Welcome to Password Guardian!")
      puts "Choose an option:"
      puts "1) Password strength evaluator"
      puts "2) Password breach check"
      puts "3) Password suggestion engine"
      puts "4) Quit"
      print @pastel.cyan("Enter 1, 2, 3, or 4: ")
      choice = STDIN.gets.chomp

      case choice
      when '1'
        strength_flow
      when '2'
        breach_flow
      when '3'
        suggestion_flow
      when '4'
        puts @pastel.yellow("Goodbye!")
        break
      else
        puts @pastel.red("Invalid choice. Please enter 1, 2, 3, or 4.")
      end
      puts  # blank line
    end
  end

  private

  def strength_flow
    pwd = @prompt.ask(@pastel.cyan("Enter password to evaluate:"))
    score, entropy = nil, nil

    with_spinner("Evaluating strength…") do
      score, entropy = password_strength(pwd)
    end

    puts @pastel.green("Password Score: #{score}/70")
    puts @pastel.green("Password Entropy: #{entropy.round(2)} bits")
  end

  def breach_flow
    pwd = @prompt.ask(@pastel.cyan("Enter password to check breach:"))
    breaches = nil

    with_spinner("Checking breach…") do
      breaches = BreachChecker.new.check_breach(pwd)
    end

    puts @pastel.red("Password breach count: #{breaches}")
  end

  def suggestion_flow
    puts "Choose an option:"
    puts "1) Strengthen an existing password"
    puts "2) Generate a new random password"
    print @pastel.cyan("Enter 1 or 2: ")
    sub = STDIN.gets.chomp

    case sub
    when '1'
      pwd = @prompt.ask(@pastel.cyan("Enter your current password:"))
      new_pass = nil
      with_spinner("Strengthening…") { new_pass = strengthen_password(pwd) }
      puts @pastel.blue("Your strengthened password is: #{new_pass}")

    when '2'
      len = @prompt.ask(
        @pastel.cyan("Enter desired password length (default 16):"),
        convert: :int,
        default: 16
      )
      new_pass = nil
      with_spinner("Generating…") { new_pass = generate_password(len) }
      puts @pastel.blue("Your new password is: #{new_pass}")

    else
      puts @pastel.red("Invalid choice.")
    end
  end

  # spinner helper
  def with_spinner(message)
    spinner = TTY::Spinner.new(@pastel.yellow("[:spinner] #{message}"), format: :pulse_2)
    spinner.auto_spin
    sleep(1)  # simulate work; adjust/remove in production
    spinner.stop(@pastel.green(" Done!"))
    yield
  end
end

# Run the CLI
PasswordCLI.new.start
