classdef Mario
    properties 
        xPos;
        yPos;
        xVel = 0;
        yVel = 0;
        image = imread('mario_standing.png');
        %Boolean checking if mario is currently jumping
        isJumping = false;
        %Boolean checking if mario is currently falling
        isFalling = false;
        %Boolean checking if mario is on a block
        onBlock = false;
        jumpingImage = imread('mario_jumping.png');
        %Boolean on whether mario can move, set to false when game is lost
        %or won
        canMove = true;
        %Boolean that checks if Mario is at the finish line and ends jump
        %function
        atFlag = false;
    end
    
    methods
        function obj = Mario(x,y)
            obj.xPos = x;
            obj.yPos = y;
        end
        
    end
end