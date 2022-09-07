
CXX=g++-12
CXXFLAGS=-Ofast -march=native -std=c++11 -lpthread -Wall -Wfatal-errors -Wextra -Wno-unused-result
RM=rm -f
EXEC=mandelbrot

all: $(EXEC)

$(EXEC):
	$(CXX) $(CXXFLAGS) $(EXEC).cpp -o $(EXEC).out

clean:
	$(RM) $(EXEC).o $(EXEC).out
