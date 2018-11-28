---
title: Rust By Example (NSS)
author: Steven Walter
...

# Rust by Example (NSS)

## What is rust?
- fast
    - compiles to machine code
    - no garbage collector

. . .

- safe
    - strongly-typed
    - guaranteed memory safety
    - threads without data races

. . .

- systems programming language
    - suitable for bare metal development
    - allows "contained" unsafety

## Who is rust?
- Started by Mozilla
- Used by many Big Tech Names
    - Dropbox
    - Canonical
    - coursera
    - Atlassian
    - System76
    - Chef
    - CoreOS
    - npm

## Why rust?
- Rust fills a need
    - C/C++ are old and problematic
    - Most modern languages are too high-level

## How rust?
- Thick Engine (most recently)
- remoteobjects
- various small utilities

## Web resources
- http://rust-lang.org
- http://play.rust-lang.org
- http://doc.rust-lang.org
- http://crates.io
- http://docs.rs

## Coding examples (1)

~~~~ {.rust}
fn main() {
    let x = format!("Hello, world!");
    println!("{}", x);
}
~~~~

It's not necessary to specify the type of "x".  The compiler is able to deduce the type.

## Rust features
- type deduction

## Coding examples (2)

Code:

~~~~ {.rust}
fn main() {
    let x = format!("Hello, world!");
    println!("{}", x, 5);
}
~~~~

Compiler output:

    error: argument never used
     --> src/main.rs:3:23
      |
    3 |     println!("{}", x, 5);
      |              ----     ^
      |              |
      |              formatting specifier missing

    error: aborting due to previous error

## Rust features
- type deduction
- compile-time checked format strings
    - number of arguments is validated

## Coding examples (3)

Code:

~~~~ {.rust}
fn main() {
    let x = format!("Hello, world!");
    println!("{} {}", x, main);
}
~~~~

Compiler output:

    error[E0277]: `fn() {main}` doesn't implement `std::fmt::Display`
     --> src/main.rs:3:26
      |
    3 |     println!("{} {}", x, main);
      |                          ^^^^ `fn() {main}` cannot be formatted with the default formatter
      |
      = help: the trait `std::fmt::Display` is not implemented for `fn() {main}`
      = note: in format strings you may be able to use `{:?}` (or {:#?} for pretty-print) instead
      = note: required by `std::fmt::Display::fmt

## Rust features
- type deduction
- compile-time checked format strings
    - number of arguments is validated
    - type of arguments is validated

## Coding examples (4)

Code:

~~~~ {.rust}
fn main() {
    let x = format!("Hello, world!");
    println!(x);
}
~~~~

Compiler output:

    error: format argument must be a string literal
     --> src/main.rs:3:14
      |
    3 |     println!(x);
      |              ^
    help: you might be missing a string literal to format with
      |
    3 |     println!("{}", x);
      |              ^^^^^

## Rust features
- type deduction
- compile-time checked format strings
    - number of arguments is validated
    - type of arguments is validated
    - format string must be a literal (security)

## Coding examples (5)

Code:

~~~~ {.rust}
fn print_stuff(x: String) {
    println!("{}", x);
}

fn main() {
    let x = format!("Hello, world!");
    print_stuff(x);
    println!("{}", x);
}
~~~~

Compiler output:

    error[E0382]: borrow of moved value: `x`
     --> src/main.rs:8:20
      |
    7 |     print_stuff(x);
      |                 - value moved here
    8 |     println!("{}", x);
      |                    ^ value borrowed here after move
      |
      = note: move occurs because `x` has type `std::string::String`, which does not implement the `Copy` trait 

## Rust features
- type deduction
- compile-time checked format strings
    - number of arguments is validated
    - type of arguments is validated
    - format string must be a literal (security)
- move by default
- no use-after-move

## Coding examples (6)

Code:

~~~~ {.rust}
fn print_stuff(x: &String) {
    println!("{}", x);
}

fn main() {
    let x = format!("Hello, world!");
    print_stuff(&x);
    println!("{}", x);
}
~~~~

Use borrow references to avoid the move

## Coding examples (7)

Code:

~~~~ {.rust}
fn print_stuff(x: &String) {
    println!("{}", x);
}

fn main() {
    let x = format!("Hello, world!");
    std::thread::spawn(|| {
        print_stuff(&x);
    });
}
~~~~

Compiler output:

    error[E0373]: closure may outlive the current function, but it borrows `x`,
    which is owned by the current function
     --> src/main.rs:7:24
      |
    7 |     std::thread::spawn(|| {
      |                        ^^ may outlive borrowed value `x`
    8 |         print_stuff(&x);
      |                      - `x` is borrowed here
      |
    note: function requires argument type to outlive `'static`
     --> src/main.rs:7:5
      |
    7 | /     std::thread::spawn(|| {
    8 | |         print_stuff(&x);
    9 | |     });
      | |______^
    help: to force the closure to take ownership of `x` (and any other referenced variables),
    use the `move` keyword
      |
    7 |     std::thread::spawn(move || {
      |                        ^^^^^^^

## Rust features
- type deduction
- compile-time checked format strings
    - number of arguments is validated
    - type of arguments is validated
    - format string must be a literal (security)
- move by default
- no use-after-move
- no data races

## Coding examples (8)

Code:

~~~~ {.rust}
static GLOBAL_THING: String = "".to_string();

fn print_stuff(x: &String) {
    println!("{}", x);
    GLOBAL_THING = x;
}

fn main() {
    let x = format!("Hello, world!");
    std::thread::spawn(|| {
        print_stuff(&x);
    });
}
~~~~

Compiler output:

    error[E0308]: mismatched types
     --> src/main.rs:5:20
      |
    5 |     GLOBAL_THING = x;
      |                    ^
      |                    |
      |                    expected struct `std::string::String`, found reference
      |                    help: try using a conversion method: `x.to_string()`
      |
      = note: expected type `std::string::String`
		 found type `&std::string::String`

## Rust features
- type deduction
- compile-time checked format strings
    - number of arguments is validated
    - type of arguments is validated
    - format string must be a literal (security)
- move by default
- no use-after-move
- no data races
- borrows can't be stolen

## Coding examples (9)

Code:

~~~~ {.rust}
static GLOBAL_THING: String = "".to_string();

fn print_stuff(x: &String) {
    println!("{}", x);
    GLOBAL_THING = x.to_string();
}

fn main() {
    let x = format!("Hello, world!");
    std::thread::spawn(move || {
        print_stuff(&x);
    });
}
~~~~

Compiler output:

    error[E0594]: cannot assign to immutable static item `GLOBAL_THING`
     --> src/main.rs:5:5
      |
    5 |     GLOBAL_THING = x.to_string();
      |     ^^^^^^^^^^^^ cannot assign

Since globals are visible to all threads, they must be const.  If they
were directly mutable, nothing would stop multiple threads from racing
the data.

## Coding examples (10)

Code:

~~~~ {.rust}
#[macro_use]
extern crate lazy_static;

use std::sync::{Arc, Mutex};
lazy_static!{
    static ref GLOBAL_THING: Arc<Mutex<String>> =
        Arc::new(
            Mutex::new(
                "".to_string()
            )
        );
}

fn print_stuff(x: &String) {
    println!("{}", x);
    let global = GLOBAL_THING.lock().unwrap();
    *global = x.to_string();
}

fn main() {
    let x = format!("Hello, world!");
    std::thread::spawn(move || {
        print_stuff(&x);
    });
}
~~~~

Compiler output:

    error[E0596]: cannot borrow `global` as mutable, as it is not declared as mutable
      --> src/main.rs:17:6
       |
    16 |     let global = GLOBAL_THING.lock().unwrap();
       |         ------ help: consider changing this to be mutable: `mut global`
    17 |     *global = x.to_string();
       |      ^^^^^^ cannot borrow as mutable

Almost there!  Wrapping the global value in a mutex makes it thread-safe.

## Rust features
- type deduction
- compile-time checked format strings
    - number of arguments is validated
    - type of arguments is validated
    - format string must be a literal (security)
- move by default
- no use-after-move
- no data races
- borrows can't be stolen
- const by default

## Coding examples (11)

Code:

~~~~ {.rust}
#[macro_use]
extern crate lazy_static;

use std::sync::{Arc, Mutex};
lazy_static!{
    static ref GLOBAL_THING: Arc<Mutex<String>> =
        Arc::new(
            Mutex::new(
                "".to_string()
            )
        );
}

fn print_stuff(x: &String) {
    println!("{}", x);
    let mut global = GLOBAL_THING.lock().unwrap();
    *global = x.to_string();
}

fn main() {
    let x = format!("Hello, world!");
    std::thread::spawn(move || {
        print_stuff(&x);
    });
}
~~~~

Marking "global" as mutable makes everything happy

## Coding examples (12)

Code:

~~~~ {.rust}
use std::collections::HashMap;

fn main() {
    let mut d = HashMap::new();
    d.insert("foo", 1);
    d.insert("bar", 2);

    for (key, value) in &d {
        println!("{} {}", key, value);
        d.remove(key);
    }
}
~~~~

Compiler output:

    error[E0502]: cannot borrow `d` as mutable because it is also borrowed as immutable
      --> src/main.rs:10:9
       |
    8  |     for (key, value) in &d {
       |                         --
       |                         |
       |                         immutable borrow occurs here
       |                         immutable borrow used here, in later iteration of loop
    9  |         println!("{} {}", key, value);
    10 |         d.remove(key);
       |         ^^^^^^^^^^^^^ mutable borrow occurs here

Classic iterator-invalidation!

## Rust features
- type deduction
- compile-time checked format strings
    - number of arguments is validated
    - type of arguments is validated
    - format string must be a literal (security)
- move by default
- no use-after-move
- no data races
- borrows can't be stolen
- const by default
- can't invalidate iterators

## Fancy macros

~~~~ {.rust}
fn main() {
    let mut doc: DOMTree<String> = html!(<h1></h1>);
    println!("{}", doc.to_string());
}
~~~~~

The typed-html crate allows you to easily include HTML in your source.
Not only that, it syntax checks the HTML at compile time looking for
correct nesting of tags, and validates that only correct tags and
appropriate attributes are used!

# Thanks!
