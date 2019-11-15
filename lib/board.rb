require "colorize"
require_relative "tile"

class Board

    attr_accessor :grid
    attr_reader :tiles, :mines, :size

    def initialize(game, size = 9, mines = 18)
        @grid = Array.new(size){Array.new(size){Tile.new(self)}}
        @game = game
        @size = size
        @mines = mines
        @tiles = tile_list
    end

    def set
        position
        set_mines
        set_mine_count
    end

    def set_mine_count
        (0..size - 1).each do |row|
            (0..size - 1).each { |col| self[row, col].mine_count }
        end
    end

    def set_mines
        until grid.flatten.count { |tile| tile.mine == true } == mines do
            plant_mine([rand(size - 1), rand(size - 1)])
        end
    end

    def plant_mine(pos)
        x, y = pos
        grid[x][y].mine = true
    end
    
    def render
       rend = grid.map do |row| 
            row.map do |tile|
                if tile.status == "hidden"
                    tile.flagged == false ? "_" : :F
                else
                    tile.mine == false ? tile.adjacent_mines : "*"
                end
            end
        end

        remaining = tiles.count { |tile| tile.mine == false && tile.status == "hidden" }
        unflagged = tiles.count { |tile| tile.mine == true && tile.flagged == false }

        if size <= 10
            puts "  #{(0..size - 1).to_a.join(" ")}".colorize(:red) 
            rend.each_with_index { |row, i| puts"#{i} ".colorize(:red) + row.join(" ") }
            puts "\n"
            puts "remaining squares: " + "#{remaining}"
            puts "unflagged mines: " + "#{unflagged}"
        else
            rend.each_with_index { |row, i| puts row.join(" ") }
            puts "\n"
            puts "remaining squares: " + "#{remaining}"
            puts "unflagged mines: " + "#{unflagged}"
        end
    end

    def display_mines
        rend = grid.map do |row| 
            row.map { |tile| tile.mine == true ? "*" : tile.adjacent_mines }
        end

        if size <= 10
            puts "  #{(0..size - 1).to_a.join(" ")}".colorize(:red)
            rend.each_with_index { |row, i| puts"#{i} ".colorize(:red) + row.join(" ") }
        else
            rend.each_with_index { |row, i| puts row.join(" ") }
        end
    end

    def mine?(pos)
        x, y = pos
        grid[x][y].mine == true
    end

    def [](x, y)
        grid[x][y]
    end

    def position
        (0..size - 1).each do |row|
            (0..size - 1).each { |col| grid[row][col].position = [row, col] }
        end
    end

    def tile_list
        list = []
        (0..size - 1).each do |row|
            (0..size - 1).each { |col| list << self[row, col] }
        end
        list
    end

end
    
        
    

