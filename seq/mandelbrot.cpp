#include <complex>
#include <iostream>

using namespace std;

int main() {
	int max_row, max_column, max_n;
	cin >> max_row >> max_column >> max_n;

	char *data = (char*)malloc(sizeof(char) * max_row * max_column);

	char **mat = (char**)malloc(sizeof(char*) * max_row);
	for (int i = 0; i < max_row; i++)
		mat[i] = data+i*max_column;

    for(int r = 0; r < max_row; ++r){
        for(int c = 0; c < max_column; ++c){
            //para cada celula da matriz
            complex<float> z;
			int n = 0;
			while(abs(z) < 2.0 && ++n < max_n) {
				float x = c * 2.0 / max_column - 1.5;
				float y = r * 2.0 / max_row - 1.0;
				z = z * z + decltype(z){x, y};
			}
			mat[r][c] = (n == max_n ? '#' : '.');
		}
	}
	for(int r = 0; r < max_row; ++r) {
		for(int c = 0; c < max_column; ++c)
			cout << mat[r][c];
		cout << endl;
	}	
}


