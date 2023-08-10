
Project Name: Mario 8-Bit
Author: Maxim Mounier

Instructions:
  Run the start file to start the game. There will be two dialog boxes, the first asking how much time in 
seconds you want the game to run and the second to ask if you want to play with sound. Note that the game runs
slower when sound is enabled, but runs perfectly smoothly when sound is disabled. 

 Controls: Space to jump
           Left arrow to move left
           Right arrow to move right
           Q to quit the game
           R to restart the game

 To win the game, Mario has to collect all the coins and reach the finish line before the time runs out.
 If the time runs out or Mario falls into one of the three pits you lose. 

 
 The intent of the project was to create a game as close as possible to the original NES mario game. 
I unfortunately was not able to add some features that I originally wanted too like enemies and multiple levels.
 
  The features I find really cool are the sound aspect. The way the mario image changes depending on if he is 
jumping or not and which direction he is moving in, and the code that checks for interesections. 

  My code demonstrates the ability to work with user created objects (Mario, the blocks and the coins were each 
their own class definition) and the ability to work with the GUI and with images, plots and audio in general. It also
demonstrates the core aspects of game development like the math behind the character's movements as well as code
efficiency. I tried my best to minimize on iteration and replotting so that the game can run as smoothly as 
possible, which is why I have all the images and sounds loaded in beforehand, and I have their handles data updated
as needed and the sound played during certain trigger events. I think overall I did a good job dividing my tasks
between multiple functions and classes so that the end product game runs smoothly and is easy to understand what
each part of the code does. 