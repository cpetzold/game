NAME = Game
VERSION = 0.1
SWF = $(NAME)-$(VERSION).swf

MXMLC = mxmlc
FLAGS = -swf-version=13 -library-path+=./libs -source-path+=./src/ -static-link-runtime-shared-libraries -debug
 
all: swf run

swf:
	@ echo "Compiling..."
	$(MXMLC) $(FLAGS) -o $(SWF) Main.as

run:
	@ echo "Running..."
	open $(SWF)

clean:
	@ echo "Cleaning..."
	rm $(SWF)