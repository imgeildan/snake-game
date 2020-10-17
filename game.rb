require 'ruby2d'

class Game
    def initialize
        @square_size = 30
        @ball_x = 10
        @ball_y = 10
        @score = 0
        @finished = false
        @no = 0
    end

    def draw(victim_animal)
        Image.new("images/#{victim_animal}.png", x: @ball_x * @square_size, y: @ball_y * @square_size, width: 30, height: 30, size: @square_size, z: 10)
        Text.new(text_message, color: 'green', x: 50, y: 10, size: 25, z: 1)
    end

    def snake_hit_ball?(x, y)
        @ball_x == x && @ball_y == y
    end

    def record_hit
        @score += 1
        @ball_x = rand(Window.width / @square_size)
        @ball_y = rand(Window.height / @square_size)
    end

    def get_score
        @score
    end

    def finish
        @finished = true
    end

    def finished?
        @finished
    end

    private

    def text_message
        if finished?
            "Your score was #{@score}      Press 'R' to restart. "
        else
            "Score: #{@score}"
        end
    end
end
