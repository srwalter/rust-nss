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

# Demo

## Rust features
> - type deduction
> - compile-time checked format strings
> - move by default
> - no use-after-move
> - no data races
> - references can't be stolen
> - can't invalidate iterators

## Fancy macros

~~~~ {.rust}
fn main() {
    let mut doc: DOMTree<String> = html!(<h1></h1>);
    println!("{}", doc.to_string());
}
~~~~~

# What do you want to see?
