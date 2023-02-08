# ECE 385

For UIUC ECE 385 Fall 2022

This repository is only for reference and I shall not be held responsible for any academic integrity violations. 

All works are accomplished together with my partner Gong Rui. 

## Final Project - PvP Battle City Game

### Introduction

![Image](https://github.com/Jiamingxu20/ECE-385/blob/master/Final/ECE385-HelperTools-master/PNG%20To%20Hex/On-Chip%20Memory/sprite_originals/gamebegin0.png)

We re-create the classic tank battle game, Batlle City, into a PvP version on FPGA board, in which two players are able to control their each tank to battle via keyboard. 



### How to run

* Pull the whole project "Final".
* Connect your computer to a FPGA board and specify in Quartus.
* Compile the project in Quartus and program the device.
* Connect your FPGA board to a monitor via VGA.
* Compile and run the C code in Eclipse.
* You are ready to play!


### How to play 

* Key Control for Players:

![Image](https://github.com/Jiamingxu20/ECE-385/blob/master/Final/ECE385-HelperTools-master/PNG%20To%20Hex/On-Chip%20Memory/sprite_originals/esc.png)


### Rules 

* There will be two players, and each player could control the his/her tank via the keyboard.

* The Player who first destroy the headquarter of the other player will win the game. 

* Each tank can shoot a cannonball and be aware of the reloading time. 

* If hit by the cannonball or collided with the other tank, the tank will reset to its inital position. 

* Players can pause the game anytime by pressing "ESC" on the keyborad.

* Players can also restart the game by pressing "ENTER" on the keyborad after one round of game.

* There are 4 kinds of function blocks and each of them will serve different functions. 

1. Iron : 
![Image](https://github.com/Jiamingxu20/ECE-385/blob/master/Final/ECE385-HelperTools-master/PNG%20To%20Hex/On-Chip%20Memory/sprite_converted/iron.png)

    Can not be passed through or destroyed by cannonball.


2. Wall : 
![Image](https://github.com/Jiamingxu20/ECE-385/blob/master/Final/ECE385-HelperTools-master/PNG%20To%20Hex/On-Chip%20Memory/sprite_converted/sw.png)

   Can not be passed through but can be destroyed by cannonball.


3. Water : 
![Image](https://github.com/Jiamingxu20/ECE-385/blob/master/Final/ECE385-HelperTools-master/PNG%20To%20Hex/On-Chip%20Memory/sprite_converted/water.png)

    Will speed up the tank.


4. Woods : 
![Image](https://github.com/Jiamingxu20/ECE-385/blob/master/Final/ECE385-HelperTools-master/PNG%20To%20Hex/On-Chip%20Memory/sprite_converted/grass.png)

    Will hide the tank. 

* Enjoy the Game!

### We left an Easter egg in the game; see if you can find it :)


