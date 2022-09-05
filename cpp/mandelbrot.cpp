#include <complex>
#include <iostream>
#include <pthread.h>

using namespace std;

const int NUM_THREADS = 8;

int max_row, max_column, max_n;
char *data, **mat;

struct thread_param_t {
	int tid, num_threads;
};

void* mandel(void *param) {
	thread_param_t* p = (thread_param_t*) param;

	for(int i = p->tid; i < max_row * max_column; i += p->num_threads){
		int r = i / max_column;
		int c = i % max_column;

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
	
	pthread_exit(NULL);
}

int main(int argc, char* argv[]) {
	int num_threads = (argc > 1 ? atoi(argv[1]) : NUM_THREADS);

	cin >> max_row >> max_column >> max_n;

	data = (char*)malloc(sizeof(char) * max_row * max_column);

	mat = (char**)malloc(sizeof(char*) * max_row);
	for (int i = 0; i < max_row; i++)
		mat[i] = data+i*max_column;

	pthread_t thread[num_threads];
	thread_param_t param[num_threads];

	for (int tid = 0; tid < num_threads; tid++) {
		param[tid] = {tid, num_threads};
		pthread_create(&thread[tid], NULL, mandel, (void*) (param+tid));
	}

	for (int tid = 0; tid < num_threads; tid++) {
		pthread_join(thread[tid], NULL);
	}

	for(int r = 0; r < max_row; ++r) {
		for(int c = 0; c < max_column; ++c)
			cout << mat[r][c];
		cout << endl;
	}	

	pthread_exit(NULL);
}


