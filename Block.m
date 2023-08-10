classdef Block
    properties 
        xPos;
        yPos;
    end
    
    properties (Constant)
        width = 50;
        height = 50;
        xVel = 0;
        yVel = 0;
        image = imread('block.png');
    end
    
    methods 
        function obj = Block(x, y)
            obj.xPos = x;
            obj.yPos = y;
        end     
    end
    
    methods (Static)

    end
        
    
        
end
    