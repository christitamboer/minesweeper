require "debugger"

class Minesweeper

  def initialize
    @board = nil
  end

  def play
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

class Square
  attr_accessor :adjacent_mines, :is_flagged, :has_mine, :is_unexplored,
                :adjacent_squares

  def initialize
    @adjacent_mines = 0
    @is_flagged = false
    @has_mine = false
    @is_unexplored = true
    @adjacent_squares = []
  end

  def display_symbol
    if @is_flagged # Flagged
      return 'F'
    elsif @is_unexplored # Not flagged, unexplored
      return '?'
    elsif @has_mine # Not flagged, explored, has_mine (Game over!)
      return '*'
    else
      if @adjacent_mines == 0 # not flagged, explored, not near any mines
        return '_'
      else
        return @adjacent_mines.to_s # Not flagged, explored, near >= 1 mines
      end
    end
  end
end

game = Minesweeper.new
board = game.make_board(9,9,10)
