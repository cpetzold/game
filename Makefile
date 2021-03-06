NAME = Game
VERSION = 0.1
SWF = ./build/game.swf
HTML = ./build/index.html

MXMLC = mxmlc
FLAGS = -swf-version=13 -library-path+=./deps/libs -source-path+=./deps/src -source-path+=./deps/nd2d/src -static-link-runtime-shared-libraries -use-network=false -debug
 
all: swf open

debug: swf fdb

web: swf browser

swf:
	$(MXMLC) $(FLAGS) -o $(SWF) ./src/Main.as

open:
	open $(SWF)

fdb:
	fdb $(SWF)

browser:
	open -a safari $(HTML)

clean:
	rm $(SWF)