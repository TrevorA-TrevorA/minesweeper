require_relative "board"

class Tile

    attr_accessor :mine, :flagged, :status, :position, :board, :adjacent_mines

    def initialize(board)
        @board = board
        @status = "hidden"
        @position = []
        @mine = false
        @flagged = false
        @adjacent_mines = 0
    end

    def adjacent?(pos)
        x, y = self.position
        
        case pos
        when [x - 1, y]
            return true
        when [x + 1, y]
            return true
        when [x, y - 1]
            return true
        when [x, y + 1]
            return true
        when [x - 1, y + 1]
            return true
        when [x - 1, y - 1]
            return true
        when [x + 1, y + 1]
            return true
        when [x + 1, y - 1]
            return true
        else
            false
        end
    end

    def mine_count
        adjacent = []
        (0..8).each do |row|
            (0..8).each do |col|
                adjacent << board[row, col] if self.adjacent?([row, col])
            end
        end
        @adjacent_mines = adjacent.count{ |tile| tile.mine == true }
    end

end