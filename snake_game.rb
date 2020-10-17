require 'ruby2d'
require './Snake'
require './Game'

set title: "Rainbow snake!"
set background: 'navy'
set fullscreen: true
set fps_cap: 10
get :mouse_x
get :mouse_y
set width: 780

snake = Snake.new
game = Game.new

@start_song = Music.new('music/play_the_game.mp3')
@start_song.loop = true
@start_song.play
@start_song.volume = 25

Text.new('Mute', color: 'yellow', x: 10, y: 5)
Text.new('Select game music (press a key)', color: 'purple', x: 100, y: 30)
Text.new('1- Matrix', color: 'green', x: 100, y: 70)
Text.new('2- Ruby :)', color: 'red', x: 100, y: 100)
Text.new('3- Closer', color: 'gray', x: 100, y: 130)
Text.new("4- Can't Touch This", color: 'yellow', x: 100, y: 160)
Text.new('5- Silent Mode', color: 'white', x: 100, y: 190)
Text.new('6- Quit', color: 'green', x: 100, y: 220)

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

on :mouse_down do |event|
  @start_song.stop if event.button == :left && event.x >= 10 && event.x <= 40 && event.y <= 35 && event.y >= 5
end

update do
    unless @song.nil?
        Text.new('Select your color', color: 'purple', x: 500, y: 30)
        Text.new('7- Green', color: 'green', x: 500, y: 70)
        Text.new('8- #FFFFFF', color: 'black', x: 500, y: 100)
        Text.new('9- Rainbow', color: 'purple', x: 500, y: 130)

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
                Text.new('Select background color', color: 'purple', x: 100, y: 280)
                Text.new('d) Dark Mode #FFFFFF', color: 'black', x: 100, y: 310)
                Text.new('n) Navy', color: 'green', x: 100, y: 340)
                Text.new('w) #000000', color: 'white', x: 100, y: 370)
                Text.new('r) Disco lights :) Random colors', color: 'green', x: 100, y: 400)
                Text.new('m) Maroon', color: 'maroon', x: 100, y: 430)

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
                        Text.new('Select victim-animal', color: 'purple', x: 500, y: 280)
                        Text.new('a) Mouse', color: 'gray', x: 500, y: 310)
                        Text.new('c) Rubber duck :)', color: 'yellow', x: 500, y: 340)
                        Text.new('b) Bugs bunny', color: 'white', x: 500, y: 370)
                        Text.new('e) Mickey Mouse', color: 'blue', x: 500, y: 400)

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
                                @start_song.stop
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
    @song.loop = true
    @song.play
    @song.volume = 80
end

update do
  set background: @background_color
    snake.draw(@color)

    if game.finished?
        Text.new('Quit', color: 'green', x: 700, y: 10)
        if @song.path.include?('matrix') || @song.path.include?('cant_touch_this')
            death_song = Sound.new('music/ops_i_did_it_again.wav')
            death_song.play
            sleep 12
            next
        else
            death_song = Sound.new('music/funeral_march_chopin.wav')
            death_song.play
            sleep 7
            next
        end
    end
    @song.resume if @song
    clear
    Text.new('Quit', color: 'green', x: 700, y: 10)
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
        game.finish
        game.draw(@victim)
        @song.pause if @song
        sleep 0.5
        Image.new('images/ruby_gem.png', x: (game.get_score >= 10 ? 261 : 246), y: 15, width: 20, height: 20)
        Image.new('images/game_over.png', x: 90, y: 100, width: 90, height: 90)
        Image.new(@song.path.include?('matrix') || @song.path.include?('cant_touch_this') ? 'images/paint_it_black.jpg' : 'images/chpn_piano.png', x: 250, y: 100, width: 100, height: 100)
        Image.new('images/angel_halo.png', x: 445, y: 80, width: 50, height: 35)
        Image.new('images/python.png', x: 420, y: 110, width: 100, height: 100)
        Text.new('Quit', color: 'green', x: 700, y: 10)
    end
end

on :mouse_down do |event|
  exit if event.button == :left && event.x >= 700 && event.x <= 745 && event.y <= 35 && event.y >= 10
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
