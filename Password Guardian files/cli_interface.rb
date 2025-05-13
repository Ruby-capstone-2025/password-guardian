require 'bundler/setup'           # load gems from Gemfile
require 'tty-prompt'              # for prompting input
require 'tty-spinner'             # for spinner animations
require 'pastel'                  # for colored output

require_relative 'password_strength'   # defines password_strength(password)
require_relative 'PasswordSuggestion'  # defines strengthen_password(password), generate_password(length)
require_relative 'Breach_Checker'      # defines class BreachChecker #check(password)

class PasswordCLI
  def initialize
    @prompt = TTY::Prompt.new
    @pastel = Pastel.new
  end

  def start
    loop do
      @prompt.say(@pastel.green("\nWelcome to Password Guardian!"))
      choice = @prompt.select("Choose an option:", cycle: true) do |menu|
        menu.choice '🧪 Password strength evaluator', :strength
        menu.choice '🛡️  Password breach check', :breach
        menu.choice '🛠️  Password suggestion engine', :suggest
        menu.choice '🚪 Quit', :quit
      end

      case choice
      when :strength then strength_flow
      when :breach   then breach_flow
      when :suggest  then suggestion_flow
      when :quit
        puts @pastel.yellow("Goodbye!")
        break
      end

      puts
    end
  end


  private

  def strength_flow
    pwd = @prompt.mask(@pastel.cyan("Enter password to evaluate:"), required: true)
    score, entropy = with_spinner("Evaluating strength…") { password_strength(pwd) }

    puts @pastel.green("✅ Password Score: #{score}/70")
    puts @pastel.green("🔐 Password Entropy: #{entropy.round(2)} bits")
  end

  def breach_flow
    breach_instance = Breach_Checker.new
    pwd = @prompt.mask(@pastel.cyan("Enter password to check for breach:"), required: true)
    breaches = with_spinner("Checking breach…") do
      breach_instance.check(pwd)
    end

    if breaches > 0
      puts @pastel.red("⚠️  Password found in #{breaches} known data breach(es)!")
    else
      puts @pastel.green("✅ Your password was NOT found in any known breach.")
    end
  end

  def suggestion_flow
    sub_choice = @prompt.select(@pastel.cyan("Choose an option:"), cycle: true) do |menu|
      menu.choice '🔧 Strengthen an existing password', :strengthen
      menu.choice '🎲 Generate a new random password', :generate
    end

    case sub_choice
    when :strengthen
      pwd = @prompt.mask(@pastel.cyan("Enter your current password:"), required: true)
      new_pass = with_spinner("Strengthening…") { strengthen_password(pwd) }
      puts @pastel.blue("🔑 Your strengthened password is: #{new_pass}")

    when :generate
      len = @prompt.ask(@pastel.cyan("Enter desired password length (default 16):"), convert: :int, default: 16)
      new_pass = with_spinner("Generating…") { generate_password(len) }
      puts @pastel.blue("🔑 Your new password is: #{new_pass}")
    end
  end

  # Spinner helper that returns block result
  def with_spinner(message)
    spinner = TTY::Spinner.new(@pastel.yellow("[:spinner] #{message}"), format: :pulse_2)
    spinner.auto_spin
    result = yield
    sleep(0.5) # Optional delay for UX
    spinner.stop(@pastel.green(" Done!"))
    result
  end
end

# Run the CLI
PasswordCLI.new.start
