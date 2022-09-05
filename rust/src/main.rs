use num::complex::{Complex32, ComplexFloat};
use rayon::prelude::*;
use text_io::read;

#[inline(always)]
fn mandel(mc: f32, mr: f32, mn: i32, r: f32, c: f32) -> char {
    let mut n = 0;
    let mut z = Complex32::default();
    while z.abs() < 2.0 {
        n += 1;
        if n == mn {
            break;
        }
        let x = c * 2.0 / mc - 1.5;
        let y = r * 2.0 / mr - 1.0;
        z = z * z + Complex32::new(x, y);
    }
    if n == mn {
        '#'
    } else {
        '.'
    }
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if let Some(Ok(num_threads)) = args.get(1).map(|arg| arg.parse()) {
        rayon::ThreadPoolBuilder::new()
            .num_threads(num_threads)
            .build_global()
            .unwrap();
    }

    let max_row: usize = read!();
    let max_column: usize = read!();
    let max_n: i32 = read!();

    let mut data = vec!['.'; max_row * max_column].into_boxed_slice();

    data.par_iter_mut().enumerate().for_each(|(i, cell)| {
        let r = (i / max_column) as f32;
        let c = (i % max_column) as f32;
        *cell = mandel(max_column as f32, max_row as f32, max_n, r, c)
    });

    for line in data.chunks(max_column) {
        for cell in line {
            print!("{}", cell);
        }
        println!();
    }
}
