require "debugger"
require "./square"
require "./prompt"

class Minesweeper

  def initialize
    @board = nil
    @game_over = false
  end

  def get_board

    print "Enter board size: small (9x9) or medium (16x16): "
    board_size = gets.chomp.downcase

    case board_size
    when "small"
      @board = make_board(9, 9, 10)
    when "medium"
      @board = make_board(16, 16, 40)
    else
      puts "Invalid choice, setting to small!"
      @board = make_board(9, 9, 10)
    end
  end

  def get_command
    # Prompt for position
    prompt_msg = "Enter command to reveal(r)/flag(f) row and col (e.g. r 0 2): "
    error_msg = "Invalid input\n"
    prompt(prompt_msg, error_msg) do |input|
      # Is separated by spaces
      is_valid = input.split(' ').count == 3


      cmd, row, col = input.split(' ')
      # Is a valid command
      is_valid &&= cmd.downcase == 'r' || cmd.downcase == 'f'

      # Is in range
      is_valid &&= row.to_i.between?(0, @board.length - 1)
      is_valid &&= col.to_i.between?(0, @board[0].length - 1)


      is_valid = true if input == "quit"
    end
  end

  def play
    print "Enter your name: "
    name = gets.chomp

    get_board

    display_board

    until @game_over
      command_str = get_command
      return if command_str == "quit"

      cmd, row, col = command_str.split(' ')
      row = row.to_i
      col = col.to_i

      update_board(cmd, row, col)

      display_board

      check_win
    end

    puts "Game Over!"

    # Show revealed
    display_board(true)

  end

  def check_win
    won = true

    num_flagged = 0
    num_mines = 0
    @board.flatten.each do |square|
      won &&= (square.is_revealed || square.is_flagged)
      num_flagged += 1 if square.is_flagged
      num_mines += 1 if square.has_mine
    end

    won &&= (num_mines == num_flagged)

    if won
      puts "You won!"
      @game_over = true
    end

  end

  def update_board(cmd, row, col)
    square = @board[row][col]
    @game_over = true if cmd == 'r' && square.has_mine

    square.update(cmd)
  end

  def display_board(reveal_all = false)
    if reveal_all
      # Show revealed
      @board.flatten.each do |square|
        square.is_revealed = true
      end
    end

    puts

    # Display row header
    puts "  " + (0..@board[0].length-1).to_a.map(&:to_s).join(' ')
    puts "  " + "--" * @board[0].length

    # Display board
    @board.each_with_index do |row, r|
      print "#{r}|" # Display column header
      row.each do |square|
        print square.display_symbol + " " # Print square
      end
      puts
    end

    puts
  end

  def make_board_with_mines(board, mines)
    # Generate random mine positions
    mine_positions = []
    until mine_positions.length == mines
      row = rand(board.length)
      col = rand(board[0].length)
      mine_positions << [row, col] if !mine_positions.include?([row, col])
    end

    # For each mine
    mine_positions.each do |pos|
      row, col = pos
      # Add mine to board
      board[row][col].has_mine = true

      # Increment number of adjacent mines counter on adjacent squares

      board[row][col].adjacent_squares.each do |adj_square|
       adj_square.adjacent_mines += 1
      end
    end

    board
  end

  def make_board(rows, cols, mines)
    # Create empty board
    board = Array.new(rows) { Array.new(cols) { Square.new } }

    # Set each squares adjacent squares list
    board.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        adjacent_positions([row_idx, col_idx], rows, cols).each do |adj_pos|
          adj_row, adj_col = adj_pos
          board[row_idx][col_idx].adjacent_squares += [board[adj_row][adj_col]]
        end
      end
    end

    board = make_board_with_mines(board, mines)

    return board
  end

  def adjacent_positions(pos, rows, cols)
    adj_positions = []

    [-1,0,1].each do |r|
      [-1,0,1].each do |c|
        row = pos[0]+r
        col = pos[1]+c

        out_of_bounds = (row >= rows || row < 0 || col >= cols || col < 0)
        adj_positions << [row, col] unless out_of_bounds || (r==0 && c==0)
      end
    end
    adj_positions
  end
end



game = Minesweeper.new
game.play
