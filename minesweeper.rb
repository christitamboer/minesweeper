require "debugger"
require "./square"
require "./player"
require "./prompt"

class Minesweeper

  def initialize
    @board = nil
  end

  def play
    print "Enter your name: "
    name = gets.chomp

    print "Enter board size: small (9x9) or medium (16x16): "
    board_size = gets.chomp.downcase

    case board_size
    when "small"
      @board = make_board(9, 9, 10)
    when "medium"
      @board = make_board(16, 16, 40)
    else
      puts "Invalid choice, setting to small. "
      @board = make_board(9, 9, 10)
    end

    game_over = false
    until game_over
      prompt_msg = "Enter row and col (e.g. 0 2): "
      error_msg = "Invalid position\n"
      pos_str = prompt(prompt_msg, error_msg) do |input|
        # Is separated by a space
        is_valid = input.split(' ').count == 2

        # Is in range
        row, col = input.split(' ')
        is_valid &&= row.to_i.between?(0, @board.length-1)
        is_valid &&= col.to_i.between?(0, @board[0].length-1)
      end

      row, col = pos_str.split(' ').map(&:to_i)
    end

  end

  def display_board
    @board.each do |row|
      row.each do |square|
        print square.display_symbol
      end
      puts
    end
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

    # Generate random mine positions
    mine_positions = []
    until mine_positions.length == mines
      row = rand(rows)
      col = rand(cols)
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
