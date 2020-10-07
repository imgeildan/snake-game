require 'ruby2d'
require './Snake'
require './Game'

set title: "Rainbow snake!"
set background: 'navy'
set fullscreen: true
set fps_cap: 10
get :mouse_x
get :mouse_y

snake = Snake.new
game = Game.new

Text.new('Select game music (press a key)', color: 'purple', x: 30, y: 30, size: 20, z: 1)
Text.new('1- Matrix', color: 'green', x: 10, y: 70, size: 20, z: 1)
Text.new('2- Ruby :)', color: 'red', x: 10, y: 100, size: 20, z: 1)
Text.new('3- Closer', color: 'gray', x: 10, y: 130, size: 20, z: 1)
Text.new("4- Can't Touch This", color: 'yellow', x: 10, y: 160, size: 20, z: 1)
Text.new('5- Silent Mode', color: 'white', x: 10, y: 190, size: 20, z: 1)
Text.new('6- Quit', color: 'green', x: 10, y: 220, size: 20, z: 1)

on :key_down do |event|
    case event.key
    when '1'
        @song = Music.new('music/matrix.mp3')
    when '2'
        @song = Music.new('music/ruby.mp3')
    when '3'
        @song = Music.new('music/closer.mp3')
    when '4'
        @song = Music.new('music/cant_touch_this.mp3')
    when '5'
        @song = false
    when '6'
        exit
    end
end

update do
    unless @song.nil?
        Text.new('Select your color', color: 'purple', x: 400, y: 30, size: 20, z: 1)
        Text.new('7- Green', color: 'green', x: 390, y: 70, size: 20, z: 1)
        Text.new('8- #FFFFFF', color: 'black', x: 390, y: 100, size: 20, z: 1)
        Text.new('9- Rainbow', color: 'purple', x: 390, y: 130, size: 20, z: 1)

        on :key_down do |event|
            case event.key
            when '7'
               @color = 'green'
            when '8'
               @color = 'black'
            when '9'
               @color = 'rainbow'
            end
        end

        update do
            unless @color.nil?
                Text.new('Select background color', color: 'purple', x: 30, y: 280, size: 20, z: 1)
                Text.new('d) Dark Mode #FFFFFF', color: 'black', x: 10, y: 310, size: 20, z: 1)
                Text.new('n) Navy', color: 'green', x: 10, y: 340, size: 20, z: 1)
                Text.new('w) #000000', color: 'white', x: 10, y: 370, size: 20, z: 1)
                Text.new('r) Disco light :) Random colors', color: 'green', x: 10, y: 400, size: 20, z: 1)
                Text.new('m) Maroon', color: 'maroon', x: 10, y: 430, size: 20, z: 1)

                on :key_down do |event|
                   case event.key
                   when 'd'
                       @background_color = 'black'
                   when 'n'
                       @background_color = 'navy'
                   when 'w'
                       @background_color = 'white'
                   when 'r'
                       @background_color = 'random'
                   when 'm'
                       @background_color = 'maroon'
                    end
                end

                update do
                    unless @background_color.nil?
                        Text.new('Select victim animal', color: 'purple', x: 360, y: 280, size: 20, z: 1)
                        Text.new('a) Mouse', color: 'gray', x: 370, y: 310, size: 20, z: 1)
                        Text.new('c) Rubber duck :)', color: 'yellow', x: 370, y: 340, size: 20, z: 1)
                        Text.new('b) Bugs bunny', color: 'white', x: 370, y: 370, size: 20, z: 1)
                        Text.new('e) Mickey Mouse', color: 'blue', x: 370, y: 400, size: 20, z: 1)

                        on :key_down do |event|
                            case event.key
                            when 'a'
                                @victim = 'mouse'
                            when 'c'
                                @victim = 'rubber_duck'
                            when 'b'
                                @victim = 'bugsbunny'
                            when 'e'
                                @victim = 'micky'
                            end
                        end

                        update do
                            unless @victim.nil?
                                close
                            end
                        end
                     end
                end
            end
        end
    end
end
show

if @song
    @song.play
    @song.loop = true
    @song.volume = 80
end

update do
  set background: @background_color
    snake.draw(@color)

    if game.finished?
        t = Time.now

        Text.new('Quit', color: 'green', x: 500, y: 10, size: 25, z: 1)
        death_song = Sound.new('music/funeral_march_chopin.wav')
        death_song.play
        sleep 7
        if Time.now == t + 7 then next end
    end
    @song.resume if @song
    clear
    Text.new('Quit', color: 'green', x: 500, y: 10, size: 25, z: 1)
    unless game.finished?
        snake.move
    end

    snake.draw(@color)
    game.draw(@victim)

    if game.snake_hit_ball?(snake.x, snake.y)

        game.record_hit
        snake.grow

        if @song
            @song.pause
            if @song.path == 'music/matrix.mp3'
                yummy = Sound.new('music/yummy.wav')
                yummy.play
                sleep 2
            else
                sleep 0.1
            end
            @song.resume
        end
    end

    if snake.hit_itself?
        clear
        @song.pause if @song
        game.finish
        game.draw(@victim)
        Image.new('images/ruby_gem.png', x: 216, y: 15, width: 20, height: 20, size: 5, z: 1)
        Image.new('images/game_over.png', x: 50, y: 50, width: 90, height: 90, size: 50, z: 10)
        Image.new('images/chpn_piano.png', x: 200, y: 50, width: 100, height: 100,size: 150,z: 10)
        Image.new('images/angel_halo.png', x: 430, y: 45, width: 50, height: 35, size: 5, z: 1)
        Image.new('images/python.png', x: 400, y: 75, width: 100, height: 100, size: 70, z: 10)
        Text.new('Quit', color: 'green', x: 500, y: 10, size: 25, z: 1)
    end
end

on :mouse_down do |event|
  exit if event.button == :left && event.x >= 500 && event.x <= 545 && event.y <= 35 && event.y >= 10
end

on :key_down do |event|
    if ['up', 'down', 'left', 'right'].include?(event.key)
        if snake.can_change_direction_to?(event.key)
          snake.direction = event.key
        end
    end

  if game.finished? && event.key == 'r'
    snake = Snake.new
    game = Game.new
  end
end

show
