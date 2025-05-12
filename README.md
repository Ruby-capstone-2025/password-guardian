# Password Guardian

A simple Ruby CLI tool to evaluate password strength, check password breaches via the HaveIBeenPwned API, and generate or strengthen passwords.

## Prerequisites

* **Ruby** (>= 2.7)
* **Bundler** gem
* **VSCode** (optional, with Ruby LSP extension for development)

## Install dependencies

   ```bash
   gem install bundler        # if Bundler is not already installed
   bundle install             # installs gems from Gemfile
   ```

## Running the Program

```bash
ruby cli_interface.rb
```

Select an option by typing the number and pressing Enter.

```
Welcome to Password Guardian!
Choose an option:
1) Password strength evaluator
2) Password breach check
3) Password suggestion engine
4) Quit
Enter 1, 2, 3, or 4:
```

## File Structure

```
password_guardian/
├── cli_interface.rb          # Main CLI entry point
├── password_strength.rb      # Password strength evaluation logic
├── PasswordSuggestion.rb     # Password strengthening & generation logic
├── breach_checker.rb         # HaveIBeenPwned breach check logic
├── Gemfile                   # Defines project dependencies
└── README.md                 # Project documentation
```

