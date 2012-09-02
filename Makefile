NAME = Game
VERSION = 0.1
SWF = ./build/$(NAME)-$(VERSION).swf

MXMLC = mxmlc
FLAGS = -swf-version=13 -library-path+=./deps/libs -source-path+=./deps/src -source-path+=./deps/nd2d/src -static-link-runtime-shared-libraries -debug
 
all: swf run

swf:
	@ echo "Compiling..."
	$(MXMLC) $(FLAGS) -o $(SWF) ./src/Main.as

run:
	@ echo "Running..."
	open $(SWF)

clean:
	@ echo "Cleaning..."
	rm $(SWF)