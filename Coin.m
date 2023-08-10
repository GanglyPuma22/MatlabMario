classdef Coin
    properties 
        xPos;
        yPos;
        %Boolean checking if coin has been collected
        collected = false;
    end
    
    properties (Constant)
        width = 30;
        height = 30;
        xVel = 0;
        yVel = 0;
        image = imread('coin.png');
     
    end
    
    methods 
        function obj = Coin(x, y)
            obj.xPos = x;
            obj.yPos = y;
        end     
    end
end