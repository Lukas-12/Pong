--open -n -a love ~/Desktop/Löve
love.window.setMode( 600, 600) -- Set a window 600x600

function love.load() -- load variables etc

Start = false
gamestate = "title"
currspeed = 3
titlespeed = 3

--set images and sounde
plus = love.graphics.newImage("plus.png")
minus = love.graphics.newImage("minus.png")
enter = love.graphics.newImage("enter.png")
song = love.audio.newSource("bounce.wav", "static")

titleSong = love.audio.newSource("title.mp3","stream")
titleSong:setLooping(true)

--left = left paddel
leftX = 50
leftY = 250

--right = right paddel
rightX = 550
rightY = 250

-- score
scoreLeft = 0
scoreRight = 0

-- ball
ballX = 300
ballY = 300
ballMoveY = -3
rand = 0
end

function love.update(dt) --Fenster wird aktualisiert(damit sich was bewegt)
   
    if gamestate == "title" then      --Titelbildschirm  
        love.audio.play(titleSong)
        titleSong:setVolume(1)
        
        if love.keyboard.isDown('return') then
            
          gamestate = "play"
          titleSong:setVolume(0.2)
        end

else

    if love.keyboard.isDown('escape') then  
        gamestate = 'title'
    end   


if love.keyboard.isDown('space') then  
    Start = true
end    

if (Start == true) then
    ballX = ballX + currspeed
    ballY = ballY + ballMoveY
end
checkCollision(ballX,ballY)

--Paddle left move
if love.keyboard.isDown('w') and leftY > 0 then
    leftY = leftY - 400 * dt
    end

if love.keyboard.isDown('s') and leftY < 500 then
    leftY = leftY + 400 * dt
    end    

--Paddle right move
if love.keyboard.isDown('up') and rightY > 0 then
     rightY = rightY - 400 * dt
    end
if love.keyboard.isDown('down') and rightY < 500 then
    rightY = rightY + 400 * dt
    end
end

function love.draw() -- Hier wird alles gezeichnet
    --Titelbildschirm
    
    if gamestate == "title" then                        
        love.graphics.setBackgroundColor(1, 0.51, 1)
        
        love.graphics.setColor(1,1,0)
        love.graphics.draw(enter,150, 90, 0, 1, 1)
        love.graphics.setColor(0,0,0)
        love.graphics.print("Current speed =  " .. titlespeed ,200, 200,0,1.5,1.5)

        
        love.graphics.draw(plus,325, 255, 0, 2, 2)
        love.graphics.print("increase speed", 300,285,0,0.9,0.9)
        love.graphics.print("decrease speed", 190,285,0,0.9,0.9)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(minus,210, 250 ,0, 2, 2)
        

       
        
      else
        --Spielbildschirm
        

    --Draw a rectangle as border
   love.graphics.setColor(.14, .36, .46)
   love.graphics.rectangle('fill', 0, 0, 600, 600)

    --Draw the paddles
    love.graphics.setColor(.00, .00, .00)
    love.graphics.rectangle("fill", leftX, leftY, 10, 100) --("fill", x, y, breite, höhe)
    love.graphics.rectangle("fill", rightX, rightY, 10, 100) --("fill", x, y, breite, höhe)

    --Draw the score
    love.graphics.print(scoreLeft, 150,30,0,1.5,1.5)
    love.graphics.print(scoreRight, 450,30,0,1.5,1.5)

    --Draw a line in the middle of the window
    love.graphics.line(300,0,300,600)

    --Draw the ball
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle( "fill", ballX, ballY, 10 )

    if Start == false then
        love.graphics.setColor(.00, .00, .00)
        love.graphics.print("Press Space", 250,320,0,1.5,1.5)
        end  
    end
end


    --check if the ball hits the paddle or the wall
    function checkCollision(ballX, ballY)

        --Check if the ball is behind a Paddle
        if(ballX < 0) then
            scoreRight = scoreRight + 1
            resetBall()
        end
        if(ballX > 600) then
            scoreLeft = scoreLeft + 1
            resetBall()
        end

        --Check if the ball hits a paddle
        if(ballX <= 50 and ballX >= 40 and ballY >= leftY and ((leftY+100)-ballY) >= 0) then
            ballX = 60
            love.audio.play(song)
            moveBallPaddle()
        end
        if(ballX >= 550 and ballX <= 560 and ballY >= rightY and ((rightY+100)-ballY) >= 0) then
            ballX = 540
            love.audio.play(song)
            moveBallPaddle()
        end

        --Check if ball hits the wall
        if(ballY < 10) then
            
            love.audio.play(song)
            ballMoveY = love.math.random( 0, titlespeed )
        end
        if(ballY > 590) then
            
            love.audio.play(song)
            ballMoveY = love.math.random( -titlespeed, 0 )
        end
 
    end

    --Bring the ball back to start and goes a random way
    function resetBall()
        ballX = 300
        ballY = 300
        ballMoveY = love.math.random( -currspeed, currspeed )
         
        if(love.math.random(-1,1) >0) then
            currspeed = currspeed
        else currspeed = -currspeed
        end
        Start = false
    end

    --Change the direction of the ball
    function moveBallPaddle()
        currspeed = currspeed *(-1)
        ballMoveY = love.math.random( -currspeed, currspeed )
    end
end  

    --überprüft wo und ob die Maus gedrückt wurde
function love.mousepressed(x, y) 
    if x >= 325 and x <= 350  and y >= 255 and y <= 280 then
        titlespeed = titlespeed+1
        if currspeed < 0 then
            currspeed = currspeed -1
        else currspeed = currspeed + 1
        end
    end

    if x >= 210 and x <= 235  and y >= 255 and y <= 280 then
        titlespeed = titlespeed-1
        if currspeed < 0 then
            currspeed = currspeed +1
        else currspeed = currspeed -1
        end
        if titlespeed <= 1 then
            titlespeed = 1
        end
    end
end 
    
