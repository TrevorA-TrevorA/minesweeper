require_relative "board"
require_relative "game"

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

    def valid?(pos)
        x, y = pos
        return false if !(0...board.size).to_a.include?(x)
        return false if !(0...board.size).to_a.include?(y)
        true
    end

    def adjacent
        adj = []
        x, y = self.position
        adj << board[x - 1, y] if valid?([x - 1, y])
        adj << board[x + 1, y] if valid?([x + 1, y])
        adj << board[x, y - 1] if valid?([x, y - 1])
        adj << board[x, y + 1] if valid?([x, y + 1])
        adj << board[x - 1, y - 1] if valid?([x - 1, y - 1])
        adj << board[x - 1, y + 1] if valid?([x - 1, y + 1])
        adj << board[x + 1, y - 1] if valid?([x + 1, y - 1])
        adj << board[x + 1, y + 1] if valid?([x + 1, y + 1])
        adj
    end

    def mine_count
       @adjacent_mines = self.adjacent.count { |tile| tile.mine == true }
    end

end