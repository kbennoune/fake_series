#[macro_use]
extern crate rutie;
extern crate rand;
extern crate stats;

use rutie::{Class, Object, Float};
use rand::{thread_rng, Rng};

class!(FakeSeriesRust);

methods!(
    FakeSeriesRust,
    _itself,

    fn pub_random_normal() -> Float {
        Float::new(random_normal())
    }

);

pub fn random_normal() -> f64 {
    let mut rng = thread_rng();
    
    let mut r_2: f64;
    let mut x: f64;
    let mut y: f64;

    loop {
        x = (rng.gen::<f64>() * 2.0) - 1.0;
        y = (rng.gen::<f64>() * 2.0) - 1.0;


        r_2 = x.powi(2) + y.powi(2);

        if  r_2 <= 1.0 && r_2 > 0.0 {
            break;
        }
    }

    x * ((-2.0 * r_2.ln() / r_2)).sqrt()
}

#[allow(non_snake_case)]
#[no_mangle]
pub extern "C" fn Init_fake_series_rust_extension() {
    Class::new("FakeSeriesRust", None).define(|itself| {
        itself.def_self("random_normal", pub_random_normal);
    });
}

#[cfg(test)]
#[macro_use] 
extern crate more_asserts;

mod tests {
    #[test]
    fn random_normal_is_normal_distribution() {
        let distribution = (1..10000).map(|_| 
            crate::random_normal()
        );

        let sum: f64 = distribution.clone().sum();
        let std_dev: f64 = stats::stddev(distribution.clone());

        let avg: f64 = sum / 10000 as f64;

        assert_lt!((avg - 0.0).abs(), 0.02);
        assert_lt!((std_dev - 1.0).abs(), 0.01);
    }
}