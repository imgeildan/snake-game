require 'ruby2d'
class Snake
    attr_writer :direction

    def initialize
      @square_size = 30
      @positions = [[2, 0], [2, 1], [2, 2], [2,3]]
      @direction = 'down'
      @growing = false
    end

    def draw(color)
        @positions.each do |position|
        array = case color
                when 'rainbow'
                    ['green', 'purple', 'red', 'yellow']
                when 'black'
                    ['black']
                when 'green'
                    ['green']
                end
        Square.new(x: position[0] * @square_size, y: position[1] * @square_size, size: @square_size - 1, color: array.sample)
        end
    end

    def grow
      @growing = true
    end

    def move
        if !@growing
          @positions.shift
        end

        @positions.push(next_position)
        @growing = false
    end

    def can_change_direction_to?(new_direction)
        case @direction
        when 'up' then new_direction != 'down'
        when 'down' then new_direction != 'up'
        when 'left' then new_direction != 'right'
        when 'right' then new_direction != 'left'
        end
    end

    def x
        head[0]
    end

    def y
        head[1]
    end

    def next_position
        if @direction == 'down'
            new_coords(head[0], head[1] + 1)
        elsif @direction == 'up'
            new_coords(head[0], head[1] - 1)
        elsif @direction == 'left'
            new_coords(head[0] - 1, head[1])
        elsif @direction == 'right'
            new_coords(head[0] + 1, head[1])
        end
    end

    def hit_itself?
        @positions.uniq.length != @positions.length
    end

    private

    def new_coords(x, y)
        grid_width = Window.width / @square_size
        grid_height = Window.height / @square_size
        [x % grid_width , y % grid_height]
    end

    def head
        @positions.last
    end
end
