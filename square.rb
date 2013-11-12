class Square
  attr_accessor :adjacent_mines, :is_flagged, :has_mine, :is_revealed,
                :adjacent_squares

  def initialize
    @adjacent_mines = 0
    @is_flagged = false
    @has_mine = false
    @is_revealed = false
    @adjacent_squares = []
  end

  def display_symbol
    if @is_flagged # Flagged
      return 'F'
    elsif !@is_revealed # Not flagged, unexplored
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

  def update(cmd)
    if cmd == 'f' # Flag
      self.is_flagged = !self.is_flagged # toggle flag
    else # Reveal
      unless self.is_flagged
        self.is_revealed = true
        self.reveal_blanks([])
      end
    end
  end

  def reveal_blanks(blank_squares)
    # base case
    return unless @adjacent_mines == 0 || @is_flagged

    # recursively reveal blank squares
    blank_squares += [self]
    @adjacent_squares.each do |adj_square|
      adj_square.is_revealed = true
      adj_square.reveal_blanks(blank_squares) unless blank_squares.include?(adj_square)
    end
  end
end
