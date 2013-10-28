# Repeatedly prompts user for valid input (which is passed in as a block)
# Then returns the valid input
def prompt(prompt_message, error_message, &is_valid)
        input = nil
        invalid = true
        is_valid = Proc.new { |input| true } unless block_given?

        while invalid
                print prompt_message
                input = gets.chomp

                invalid = !is_valid.call(input)
                print error_message if invalid
        end

        input
end