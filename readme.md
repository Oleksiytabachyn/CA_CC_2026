#Playing music with game of life


Name: Oleksiy Tabachyn

Student Number: A00043525

This project was done alone



# Video demonstration

[![YouTube](http://img.youtube.com/vi/J7bkLX-bvhg/0.jpg)](https://youtu.be/J7bkLX-bvhg)

# Screenshots

This is an image using a relative URL:

![An image](../images/p8.png)

This is an image using an absolute URL:

![A different image](https://bryanduggandotorg.files.wordpress.com/2019/02/infinite-forms-00045.png?w=595&h=&zoom=2)



# Description of the project

This project is based on a famous John Conway's Game of life. The main inspitration behind this came to me during one of our lectures, this was to somehow add music to the game of life. This project is the end result of this idea and i am pretty proud of it, more about how it works will be later and for now ihope you'll enjoy my work.

# Instructions for use

To start the game you just need to press the start button located in the top-right corner. But if you do it right away this will not produce good result as the board is empty by default, to fill it you can either paint with your mouse or press randomize button to randomize the board, both of this thing can also be done while the game is running. If you want to stop the game press stop button which is the same button as start, you can also reset the board by pressing reset button. All other buttons are customizations that you can apply. There are buttons for picking the color of dead and alive cells, sliders to choose game speed and board size, also you can pick what instruments play when cells are created, die, stay alive or stay dead as well as the highest and the lowest note. The last thing is saving system, to use it pick a spot where you want to save it(1-10) give your save a name and save it.

# How it works:

## The game of life

First i will briefly touch on how the game of life works. It creates matrix which functions as the board and fills it with true and false values, each turn it counts number of alive neighbours for each cells and stores them in a different matrix, then if the cell is alive and has 2 or 3 living neighbours it lives on, otherwise it dies, if dead cell has exactly 3 alive neighbours it becomes alive.

## Generating music
Second step is to generate music out of this i chose methid that works like this: each cell has a unique cordinate that is calculated like this row*50+column, i add all of those cordinates for cells that died, were born, stayed alive or stayed dead into four variables. Then for each of those variables i calculate a note that is supposed to play using this formula sum%(high-low)+low , where sum is the sum of coordinates, low and high are highest and lowest note respecively. Then it plays the those notes that are turned on.

# List of classes/assets in the project

| Class/asset | Source |
|-----------|-----------|
| life.tcsn | Self written |
| life.gd | Self written |
| MidiPlayer | [reference](https://godotengine.org/asset-library/asset/1667) by [arlez80](https://godotengine.org/asset-library/asset?user=arlez80) |

# References
* [Godot Midi Player](https://godotengine.org/asset-library/asset/1667) By [arlez80](https://godotengine.org/asset-library/asset?user=arlez80)
* [Game of life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) by [John Conway](https://en.wikipedia.org/wiki/John_Horton_Conway)

# What I am most proud of in the assignment

- Each team member
- Must be human written. Reflect on what you achieved and share it

# What I learned

- Each team member
- Must be human written. Reflect on what you learned and share it


