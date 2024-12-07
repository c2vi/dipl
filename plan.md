

## The new Mize code approach
- Previously I had a webserver written in rust ... and the client in the browser was a js client. This js client basically reimplements everything the "instance part" of the webserver -> duplicate code to maintain.
    - a python, java, ... client was planned too
- i don't remenber when and how exactly the idea came, to have the rust code word as a MizeInstance everywhere...
    - wasm in the browser
    - wasm to jvm-bytecode for jvm
    - as a library with C bindings to use with basically every other lang ... + some fill code for that lang
- this means that the instance code needs to be completely seperated from code that deals with specific apis of a unix system....
    - and i have to say, this is the best thing ever ... it just makes the code so much clearer, cleaner.... and forces this clean-nes
        - eg in commit: a16c2f92217c79445650ce1ce2e8ef6391e849c3 I went through all the instance code i had up untill then ... and it was spagetty code like ... everywhere callig unix apis and all over the place, ....


# Einleitung

## Aufgabenstellung
- idk what exactly to write here now

## Ausarbeitungsideen
- short sumary, about what bothers me about software
- my ideas to fix this
- what this requires for making the application

# Dokumentations System
- talk about typst
- setup types language server and link to those changes in my nix config repo.....
- make typst (and markdown as well??) diplomarbeit vorlage repo and push to git.htlec.org

## Ergebnis
- was all this trouble of making 3 engines just to make a simple application worth it
- yes, because we get:
    - runns in browser and everywhere else
    - cool ecosystem
    - integrations
    - **future ecosystem possibilities**

# Theory

# Dokumentation der Arbeit

## Development Environment
- some words about nixos, my nix-config including vim, vic, ...
- nix develop or vic develop in the mize dir

## Mize a dataengine
https://github.com/c2vi/mize

### Project history
- talk about the history of this project and that it started the day i learned to code

#### CodingWiki

#### Items Project

### Switching to Rust

### Fully Custom Protocol
- my custom protocol implementation
- that was quite rubbish
- thought it would use less bytes .... 70% of bytes were 0, what a waste.... xD

### Switching to json messages

### Switching to Cbor

### Becoming Portable
Before this commit: a16c2f92217c79445650ce1ce2e8ef6391e849c3 mize would be a server, and have client implementations in many languages. Most importantly js for the browser, Python for quick programs and C for a small embedded client for uCs.

The thing with this approach is, that you would have a lot of functionality (eg the one for updating items) implemented multiple times, across the server and all client-implementations.

- explain the new layout of the mize project

#### Wasm
- we can run rust in wasm, and call js funcs from there

#### JVM
- there is this project, that transpiles wasm-bytecode to jvm-bytecode
- with this and some java bindings, we should be able to run inside jvm and be portable to everywhere with a JVM-runtime.

### Going Async
#### What is Async?

#### Implementing Async
Up untill commit: 7340aaa37ae3e5fc557910769a7e2ababffb88db

## mme a gui engine
https://github.com/c2vi/mme

### comandr a command engine
https://github.com/c2vi/comandr

## The actual application
Now we get to making the actual application.

