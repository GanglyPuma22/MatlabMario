%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Higher Level File Setus Up and Launches Game %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function start() 
    close all
    
    scoreCounter = 0;
    %How long the game lasts
    prompt = 'How much time(s) do you want to complete the course?';
    timeCounter = inputdlg(prompt); 
    timeCounter = str2double(timeCounter{1});
    
    %Boolean updated to true only when game is won or lost
    gameOver = false;
    
    %Creates Mario object used throughout the game
    mario = Mario(0,0);
    %Setus up figure window and keyPressFcn
    marioFig = figure('Units','Normalized');
    marioFig.KeyPressFcn = @moveMario;
    
    %Loads in sound beforehand to not slow down program, even if user
    %chooses not to play with sound
    if exist('theme.mp3','file')
        [themeS, themeF] = audioread('theme.mp3');
    else
        warning("Mario Sound file not found");
    end
    
    if exist('mario_dies.mp3','file')
        [dieS, dieF] = audioread('mario_dies.mp3');
    else
        warning("Mario Sound file not found");
    end
    
    if exist('mario_jump.mp3','file')
        [jumpS, jumpF] = audioread('mario_jump.mp3');
    else
        warning("Mario Sound file not found");
    end
    
    if exist('mario_coin.mp3','file')
        [coinS, coinF] = audioread('mario_coin.mp3');
    else
        warning("Mario Sound file not found");
    end
    
    if exist('mario_win.mp3','file')
        [winS, winF] = audioread('mario_win.mp3');
    else
        warning("Mario Sound file not found");
    end
    
    
    %Loads in background image
    background = imread('background.jpg');
    [backH, backW, dim] = size(background);
    %Repeats the image 11 times to set up the full background
    gameBackground = repmat(background,1,11);

    %Imports image from Mario object property and rescales it
    im = mario.image;
    im = imresize(im,0.08);
    [marH, marW, ~] = size(im);
    %Imports jumping Mario image and rescales
    jumpingIm = mario.jumpingImage;
    jumpingIm = imresize(jumpingIm, 0.22); 
    [jumpH,jumpW,~] = size(jumpingIm);
    
    %Sets up transparency data to not have background around mario
    %Same for jumping Mario
    transparency = ones(marH, marW);
    transparency(im(:,:,1) == 0) = 0;
    jumpTransparency = ones(jumpH, jumpW);
    jumpTransparency(jumpingIm(:,:,1)< 5) = 0;
    
    %Loads in flagpole Image establishes handle and changes transparency 
    % to remove border
    flagPoleIm = imread('flagPole.png');
    [flagH, flagW, ~] = size(flagPoleIm);
    flagTransparency = ones(flagH, flagW);
    flagTransparency(flagPoleIm(:,:,3)>200 & flagPoleIm(:,:,1)<200) = 0;  
    
    %Sets up blocks in a cell array
    blockArray = cell(1,55);
    blockX = 900;
    blockY = 300; 
    
    %Sets up coins in a cell array 
    coinArray = cell(1,60);
   
    %Iterates and creates each Block in blockArray and coins which will be
    %above all blocks
    for iter = 1:length(blockArray)
        if iter <= 5
            blockArray{iter} = Block(blockX,blockY); 
            coinArray{iter} = Coin(blockX, blockY - Coin.height);
        elseif iter <= 10
            blockY = 200;
            if iter == 6
                blockX = blockX + Block.width;
            end
            blockArray{iter} = Block(blockX,blockY);   
            coinArray{iter} = Coin(blockX, blockY - Coin.height);
        elseif iter <= 15
            if iter == 11
                blockX = blockX + 3*Block.width;
            end
            blockArray{iter} = Block(blockX, blockY);
            coinArray{iter} = Coin(blockX, blockY - Coin.height);
        elseif iter <= 20
            if iter == 16
                blockX = blockX + Block.width;
            end
            blockY = 300;
            blockArray{iter} = Block(blockX, blockY);
            coinArray{iter} = Coin(blockX, blockY - Coin.height);
        elseif iter <= 25
            if iter == 21
                blockX = 2700;
            end
            blockY = 300;
            blockArray{iter} = Block(blockX, blockY);
            coinArray{iter} = Coin(blockX, blockY - Coin.height);
        elseif iter <= 30
            if iter == 26
                blockX = 3150;
            end
            blockArray{iter} = Block(blockX, blockY);
            coinArray{iter} = Coin(blockX, blockY - Coin.height);
        elseif iter <= 35
            if iter == 31
                blockX = 3900;
            end
            blockArray{iter} = Block(blockX, blockY);
            coinArray{iter+5} = Coin(blockX, blockY - Coin.height);
        elseif iter <= 40
            if iter == 36
                blockY = blockY - 100;
            end
            blockArray{iter} = Block(blockX, blockY);
            coinArray{iter+5} = Coin(blockX, blockY - Coin.height);            
        elseif iter <= 45
            if iter == 41
                blockY = blockY - 100;
            end
            blockArray{iter} = Block(blockX, blockY);
            coinArray{iter+5} = Coin(blockX, blockY - Coin.height);       
        elseif iter <= 50
            if iter == 46
                blockX = 4850;
                blockY = blockY + 100;
            end
            blockArray{iter} = Block(blockX, blockY);
            coinArray{iter+5} = Coin(blockX, blockY - Coin.height);  
        elseif iter <= 55
            if iter == 51
                blockY = blockY + 100;
            end
            blockArray{iter} = Block(blockX, blockY);
            coinArray{iter+5} = Coin(blockX, blockY - Coin.height);
        end
        blockX = blockX + Block.width;
    end
    
    %Initializes the five coins that are on the ground
    coinX = 3600;
    coinArray{31} = Coin(coinX, 425 - Coin.height);
    coinArray{32} = Coin(coinX + 50, 425 - Coin.height);
    coinArray{33} = Coin(coinX + 100, 425 - Coin.height);
    coinArray{34} = Coin(coinX + 150, 425 - Coin.height);
    coinArray{35} = Coin(coinX + 200, 425 - Coin.height);
    
    %Resize block image to serve as CData later
    blockIm = Block.image;
    blockIm = imresize(blockIm, [Block.width Block.height]);
    
    %Setus up coin CData and AlphaData matrix 
    coinIm = Coin.image;
    coinIm = imresize(coinIm, [Coin.width Coin.height]);
    [coinW, coinH, ~] = size(coinIm);
    coinAlpha = ones(Coin.width, Coin.height);
    coinAlpha(coinIm(:,:,1) == 0) = 0;
    %Counts number of coins collected, used to determine if player won 
    %the game
    coinsCollected = 0;
    
    %Cell array that stores the image handles of all coins in the game
    coinHandles = cell(1,length(coinArray));
    
    %Sets up all image handles, which will be later updated throughout the
    %game. Plots the starting state of the Game
    hold on
    backgroundHandle = image(gameBackground);
    marioHandle = image(im);
    marioHandle.AlphaData = transparency;
    %Loads all the blocks onto the screen
    visualizeBlocks;
    
    %Loads all coins onto the screen and establishes handles
    for p = 1:length(coinArray)
        xData = [coinArray{p}.xPos, coinArray{p}.xPos + Coin.width];
        yData = [coinArray{p}.yPos, coinArray{p}.yPos + Coin.height];
        coinHandles{p} = image('XData',xData,'YData',yData,'CData', coinIm, ...
                 'AlphaData',coinAlpha); 
    end  
    
    %Setus up flag Pole which is the finish lane of the game
    flagPoleHandle = image(flagPoleIm);
    flagPoleHandle.AlphaData = flagTransparency;
    flagX = 5951;
    flagY = 425 - flagH;
    flagPoleHandle.XData = [flagX flagX + flagW];
    flagPoleHandle.YData = [flagY 425];
    
    %Establishes pits paramaters, used to check for game lost later
    pitSXOne = 1400;
    pitEXOne = 1600;
    pitSXTwo = 2900;
    pitEXTwo = 3200;
    pitSXThree = 4600;
    pitEXThree = 4900;
    
    %Plots pits and lines around it to preserve aestethic   
    makePit(pitSXOne,425,pitEXOne - pitSXOne, backH-425);
    makePit(pitSXTwo,425,pitEXTwo - pitSXTwo,backH-425);
    makePit(pitSXThree,425,pitEXThree - pitSXThree,backH-425);
    
    set(gca,'YDir','reverse');
    axis off;
    
    %Loads in the image for jumping mario then hides it
    marioJumpingHandle = image(jumpingIm);
    marioJumpingHandle.AlphaData = zeros(jumpH,jumpW);
    marioJumpingHandle.XData = [0 0];
    marioJumpingHandle.YData = [0 0];
    
    %Moves location where mario should start when appearing on screen
    mario.xPos = backW/2;
    %This yPos keeps Mario on the ground part of the background 
    mario.yPos = 425 - marH;
    updateMario;
    
    %Loads text that will count the score and gives it handle
    scoreText =  text(mario.xPos - backW/2, 20, "Score: " + scoreCounter, ...
        'Color','white','FontSize',14,'FontName', 'Arial','FontWeight','b');
    
    timerText = text(mario.xPos+backW/2-110, 20, "Time: " + timeCounter, ...
        'Color','white','FontSize',14,'FontName', 'Arial','FontWeight','b');
    
    hold off
    %Number of times moved used to start timer
    timesMoved = 0;
    
    %Sets up timer and text that updates every second. 
    %If player runs out of time game is lost
    t = timer;
    t.Period = 1;
    t.TimerFcn = @updateTimer;
    t.ExecutionMode = 'fixedRate';
    
    
   %Asks user if they want to play with sound and starts theme if so
   playSound = questdlg('Do you want sound?','','Yes');
   playSound = strcmp(playSound, 'Yes');
   %If user chose yes for sound load in sound into variables and start 
   %playing theme song
   if playSound
       sound(themeS,themeF);
   end

   %KeyPressFcn that moves Mario to the left or right depending on 
   %arrow keys and makes Mario jump with the space bar
   function moveMario(~,eventData)
       if timesMoved == 0
          %Starts timer once mario moves for the first time
          start(t);
       end
       timesMoved = timesMoved + 1;
       
       mario.yVel = 0;
       switch eventData.Key
           %Quit the game case
           case 'q'
               clear sound
               close all
           %Restart Game case
           case 'r'
               clear sound
               close all
               start;
           %Move right case
           case 'rightarrow'
               if mario.canMove && ...
                  mario.xPos + marW < 10*length(background) - backW/2
              
                  mario.xVel = 20;
                  updateMario;
               end
           %Move left case
           case 'leftarrow'
               if (mario.xPos > backW/2) && mario.canMove
                  mario.xVel = -20;
                  updateMario;
               end
           %Jump Case
           case 'space' 
               if ~mario.isJumping && mario.canMove 
                  mario.onBlock = false;
                  mario.isJumping = true;
                  jumpMario;
               end
           
       end
   end
    
   % Function updates marios position, the visuals depending on wheter 
   % mario is jumping or not and which direction he was traveling
   % and moves the background. Also checks if he is falling
   function updateMario
     if ~gameOver   
       %Checks for intersections with coins and sets bool collected to true
       for z = 1:length(coinArray)
           if willIntersect(coinArray{z}) && ~coinArray{z}.collected
               if playSound
                   sound(coinS,coinF);
               end
               coinArray{z}.collected = true;
               coinsCollected = coinsCollected + 1;
               scoreCounter = scoreCounter + 100;
           end
       end
      
       mario.xPos = mario.xPos + mario.xVel;
       mario.yPos = mario.yPos + mario.yVel;
       %Changes coins score value and erases them if they were collected
       updateCoins;
       %Update timer position so it stays at top right of screen
       timerText.Position = [mario.xPos+backW/2-110 20];
       
       %If mario is above a pit or out of time lose the game
       if ((mario.xPos > pitSXOne && mario.xPos+marW < pitEXOne) ||...
           (mario.xPos > pitSXTwo && mario.xPos+marW < pitEXTwo) ||...
           (mario.xPos > pitSXThree && mario.xPos+marW < pitEXThree)) && ...
           (mario.yPos == 425 - marH) || timeCounter == 0
            
            mario.xVel = 0;
            mario.yVel = 0;
            marioJumpingHandle.XData = [0 0];
            marioJumpingHandle.YData = [0 0];
            marioHandle.XData = [0 0];
            marioHandle.YData = [0 0];
            %Lose game which displays text and prevents mario
            %from moving
            loseGame;
            return;
       end
       
       %If mario is at the flagPole and has collected all the coins
       %win the game
       if mario.xPos > flagX && mario.xPos < flagX + flagW && ...
               coinsCollected == length(coinArray)
           mario.atFlag = true;
           winGame;
           return;
       end
           
       %Sets mario's on block variable to false and then checks if he is on
       %a block which will set it to true
       [mario.onBlock, ~] = checkOnBlock;
       
       %Case where mario lands on block and we should stop updateMario call
       if mario.isFalling && mario.onBlock
           return;
       end
       
       %If mario is not on the block, the ground or not in the air he has 
       %to be falling.
       if ~mario.onBlock && mario.yPos ~= 425 - marH && ~mario.isJumping ...
           && ~mario.isFalling && mario.canMove
           %If he is falling run fallMario function which updates him
           % accordingly.
           fallMario
       else 
           mario.isFalling = false;
       end
           
       %Display Image of Mario jumping towards the right 
       if mario.isJumping && mario.xVel >= 0 && mario.canMove
           marioHandle.XData = [0 0];
           marioHandle.YData = [0 0];
           marioHandle.AlphaData = zeros(marH,marW);
           marioJumpingHandle.CData = jumpingIm;
           marioJumpingHandle.AlphaData = jumpTransparency;
           marioJumpingHandle.XData = [mario.xPos, mario.xPos + jumpW];
           marioJumpingHandle.YData = [mario.yPos, mario.yPos + jumpH];
       
       %Display Image of Mario jumping towards the left
       elseif mario.isJumping && mario.xVel < 0 && mario.canMove
           marioHandle.XData = [0 0];
           marioHandle.YData = [0 0];
           marioHandle.AlphaData = zeros(marH,marW);
           marioJumpingHandle.CData = fliplr(jumpingIm);
           marioJumpingHandle.AlphaData = fliplr(jumpTransparency);
           marioJumpingHandle.XData = [mario.xPos, mario.xPos + jumpW];
           marioJumpingHandle.YData = [mario.yPos, mario.yPos + jumpH];
           
       %Display Image of Mario moving on the ground to the right
       elseif ~mario.isJumping && mario.xVel >= 0 && mario.canMove
           marioJumpingHandle.XData = [0 0];
           marioJumpingHandle.YData = [0 0];
           marioJumpingHandle.AlphaData = zeros(jumpH, jumpW);
           marioHandle.CData = im;
           marioHandle.AlphaData = transparency;
           marioHandle.XData = [mario.xPos, mario.xPos+marW];
           marioHandle.YData = [mario.yPos, mario.yPos+marH];  
       
       %Display Image of Mario moving on the ground to the left
       else
           marioJumpingHandle.XData = [0 0];
           marioJumpingHandle.YData = [0 0];
           marioJumpingHandle.AlphaData = zeros(jumpH, jumpW);
           marioHandle.AlphaData = fliplr(transparency);
           marioHandle.CData = fliplr(im);
           marioHandle.XData = [mario.xPos, mario.xPos+marW];
           marioHandle.YData = [mario.yPos, mario.yPos+marH];
           
       end
       
       %Resets Mario's yVel
       mario.yVel = 0;
       %Moves background according to mario's position
       axis([mario.xPos - backW/2, mario.xPos + backW/2, 0, backH]);
     end
   end
    
   %Function updates Mario's yVel to simulate a jump using drawnow in 
   %the loop to animate. Function also checks if Mario will land on a
   %block
   function jumpMario
       if playSound
          %Play jumping sound
          sound(jumpS,jumpF);
       end
       
       for i = 1:10
           if i <= 5
              mario.yVel = -40;
           else
               mario.yVel = 40;
           end
           for j = 1:length(blockArray)           
               if willIntersect(blockArray{j}) 
                   c = checkCollision(blockArray{j});
                   if strcmp(c, 'top') 
                       dealCollision(blockArray{j}, c);
                       %Stop the jump function
                       return;
                   end
                       
               end
           end
            if mario.atFlag
                return
            end
            updateMario
            drawnow;
       end
       mario.isJumping = false;
       
       if mario.canMove
          updateMario 
       else
           marioHandle.XData = [0 0];
           marioHandle.YData = [0 0];
           marioJumpingHandle.XData = [0 0];
           marioJumpingHandle.YData = [0 0];
       end  
       mario.xVel = 0; 
   end

    %When mario is not on a block or the ground he will be falling
    function fallMario
        mario.yVel = 20;
        if mario.xVel > 0
            mario.xVel = 1;
        else
            mario.xVel = -1;
        end
        
        %Once mario hits the ground or another block it will stop 
        while mario.yPos < 425 - marH 
           %Checks if mario falls onto another block
           for j = 1:length(blockArray)           
               if willIntersect(blockArray{j}) 
                     %Stop the fall function on the block
                     mario.yVel = 0;
                     mario.yPos = blockArray{j}.yPos - marH;
                     mario.isJumping = false;
                     return;                                          
               end    
               
           end
           
           updateMario;
           drawnow;                        
        end
        
        mario.yPos = 425 - marH;
        mario.yVel = 0;
        mario.isFalling = false;
        updateMario;
    end
    
    %Function updates timer every second
   function updateTimer(~,~)
       if timeCounter == 0
           loseGame;
       end
       timeCounter = timeCounter - 1;
       %Update timer text
       updateTimerText;
   end

    %Changes what the timer displays, so counts down the time
    function updateTimerText
       %Clip counter at 0
       if timeCounter == -1
           timeCounter = 0
       end
       timerText.String = "Time: " + timeCounter;
    end
    
    %Function removes coins from screen if they were collected
    %and updates score Text
    function updateCoins      
        for i = 1:length(coinHandles)
          %Checks if coin was collected and updates x and y data
          if coinArray{i}.collected 
              coinHandles{i}.XData = [0 0];
              coinHandles{i}.YData = [0 0];       
          end
        end
        %Updates score text
        scoreText.String = "Score: " + scoreCounter;
        scoreText.Position = [mario.xPos-backW/2 20];
       
    end

    %Displays all the blocks by iterating through blockArray and showing
    %the image
    function visualizeBlocks
        for i = 1:length(blockArray)
          xData = [blockArray{i}.xPos, blockArray{i}.xPos + Block.width];
          yData = [blockArray{i}.yPos, blockArray{i}.yPos + Block.height];
          image('XData',xData,'YData',yData,'CData', blockIm); 
        end
    end
    

    %Function checks collision with a game object, so in our case
    %between mario and a coin or mario and the brick, and returns
    % in which direction the collision occured
    function coll = checkCollision(b)
        coll = '';
        %If the collision is on the top of the object function returns
        %'top'
        if mario.xPos + marW >= b.xPos && ...
           mario.xPos <= b.xPos + b.width && ...
           mario.yPos < b.yPos &&...
           mario.yPos + marH < b.yPos
       
           coll = 'top';
        end
    end

    %Checks if mario will interect with the inputted object and returns a
    %boolean. 
    function intersect = willIntersect(obj)
        marNextX = mario.xPos + mario.xVel;
        marNextY = mario.yPos + mario.yVel;
        objNextX = obj.xPos + obj.xVel;
        objNextY = obj.yPos + obj.yVel;
        
        intersect = marNextX + marW >= objNextX &&...
                    marNextY + marH >= objNextY &&...
                    objNextX + obj.width >= marNextX && ...
                    objNextY + obj.height >= marNextY;
    end
    
    %Function that deals with a block collision and sets mario's y position
    % and other properties accordingly.
    function dealCollision(obj, coll)
        if strcmp(coll, 'top')
            mario.yPos = obj.yPos - marH;
            mario.isJumping = false;
            mario.onBlock = true;
            mario.yVel = 0;
            %mario.xVel = 0;
            updateMario
        end
    end
    
    %Checks if Mario is currently on a block or not and returns a boolean
    function [onB, yB] = checkOnBlock
       %Set output to false before check which will set it to true
       %if condition is verified
       onB = false;
       %Returns -1 by default for block position if onB will be false
       yB = -1;
       
       marY = mario.yPos + marH;
       %Checking if on block depends on what side of the block mario is on
       xLeft = mario.xPos;
       xRight = mario.xPos + marW;
       
       %Iterates over each block and cheks if mario is on one 
       for i = 1:length(blockArray)
           currX = blockArray{i}.xPos;
           currY = blockArray{i}.yPos;
           bX = currX + Block.width;
           
           if (xLeft > currX) && (marY == currY) && (xLeft < bX) || ...
              (xRight < bX) && (marY == currY) && (xRight > currX) 
               onB = true;
               yB = currY;
           end
       end
       
    end
    
    %Functions used to display game lost screen when Mario falls in a pit
    %or player runs out of time
    function loseGame
        text(mario.xPos, mario.yPos - 50, "     You Lose     " + newline + ...
        "Press R to restart", 'Color','red','FontSize',14,'FontName', 'Arial', ...
        'FontWeight','b')
    
        stop(t)
        delete(t)
        clear t
        clear sound
        
        if playSound
           %Play mario's death sound
           sound(dieS,dieF);
        end
        
        mario.canMove = false;
        gameOver = true;
        scoreText.Position = [mario.xPos-backW/2+20 20];
        timerText.Position = [mario.xPos+backW/2-150 20];
    end
    
    %Function displays game is won text once mario collects all the coins
    %and reaches the flag pole
    function winGame
        text(mario.xPos - 250, backH/2-50, "     You Win     " + newline + ...
        "Press R to restart", 'Color','red','FontSize',14, 'FontName', 'Arial', ...
        'FontWeight','b')
    
        stop(t)
        delete(t)
        clear t
        clear sound
        
        if playSound
            sound(winS,winF);
        end
        
        mario.canMove = false;
        gameOver = true;
        scoreText.Position = [mario.xPos-backW/2-20 20];
        timerText.Position = [mario.xPos+backW/2-130 20];
    end

    %Function draws the pit onto the screen
    function makePit(startX, startY, width, height)
        endX = startX + width;
        
        rectangle('Position',[startX startY width height], ...
        'FaceColor',[98/255 176/255 92/255]);
        %Green line above pit
        line([startX endX], [startY startY], ...
            'Color', [98/255 176/255 92/255]);
        %Grass green line to match ground
        line([startX startX], [startY 440],'Color',[161/255 1 110/255]);
        line([endX endX], [startY 440],'Color',[161/255 1 110/255]);
        %Brown line to match ground
        line([startX startX], [440 backH],'Color',[119/255 72/255 54/255]);
        line([endX endX], [440 backH],'Color',[119/255 72/255 54/255]);
    end
end
