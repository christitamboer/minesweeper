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
