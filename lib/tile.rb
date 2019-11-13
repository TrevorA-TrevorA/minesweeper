class Tile

    attr_accessor :mine, :flagged, :status

    def initialize
        @status = "hidden"
        @mine = false
        @flagged = false
        @adjacent_mines = 0
    end

end