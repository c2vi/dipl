

// to the implementing of mize



= The Data engine

This chapter is about the implementation of the so called "Data engine" that will form the basis of the mize platform. Other projects or products with the same or similar goals were examined in @existing. My previous attempts at making a general data management system and how the idea came to be were looked at in @hist. In this chapter we look at the latest attempt, which will hopefully also be the last. It incoperates all the learnings from previous ones as well as a lot more experience with computer systems and programming.


== The Item
Each piece of data is called an Item in this data engine. An Item works much like a mixture of the well established data storage concepts File and Folder. Files hold a list of bytes and Folders hold a list of links to other files of folders. An Item has both a list of bytes (also called the value of an item) and a list of links to other items.


=== The Type System
In an ordinary filesystem the type of the data in a file is defined by the string after the last dot or by the first few bytes of the file being a "magic value" (@Purohit2024Jan). An Item of the Mize data engine, in addition to having a list of bytes and a list of links, also has a type. The type of an item is stored as a string at the path "type". This type string is a with space seperated list of the names of one ore multiple types. A type can specify how to interpret the bytes in the value of the item and also what sub items at what paths with what types the item needs to have. This includes multiple levels, so also the sub items of sub items and so on are defined by a type. The type of the sub item is then whatever the parent item defines it to be and the type of the parent with a slash and the path, of where the sub item is at, added to it. There can however only be one type, that says how to interpret the value bytes. All the other types can only have path definitions or further define the interpretation.

This type system allows items to have really precice types, where some application needs to add special data to it, but also if an application only deals with a very generic type, it can just ignore the more specific types in the type string.

Lets look at the type system with the example of a note in my obsidian vault. It has the type string: "Note ObsidianNote MarkdownNote File MarkdownFile LinuxFile PosixFile". 

- The type "Note": defines, that the bytes in the value should be interpreted as a UTF-8 string. Applications that want to just modify or display the text of the note can see the Item as just that, a string. The type Note can therefore be seen as just an alias for "String".

- "MarkdownNote": further details that the string is actually Markdown source code. Also markdown notes can have yaml properties at the top of the source, so MarkdownNote also defines, that there is a path "properties", where all properties are mapped into.

- "ObsidianNote": is the type, which has paths, to put all information that is specific to the obsidian notetaking application (@BibObsidian). For example in Obsidian every note is part of a so called vault (@BibObsidianVault) so the type ObsidianNote will include a link at the path obsidian_note to the Item, that is a the vault the note belongs to.

- "File": Obsidian stores every note as just a markdown file on your system. So our note can also be seen as a "File" stored on some filesystem. (@BibFilesystem) This type means the value of our note item is the content of the File. And we have sub items at certain paths for file metadata, that files have on all platforms.

- "PosixFile": There is filemetadata unique to unix systems like the permission if a user is able to execute this file (@BibUnixPerms). Things like this are again stored in sub items at certain paths, which give an application acces to this unix specific data.

- "NFSv4ACL": The file that stores our note, could have special attributes called ACLs or access control lists. There was an attempt to standardise ACLs in the Posix standard, but that was withdrawn (@BibPosixACL). Many POSIX operating systems, including Linux, implement the ACLs as defined in the NFSv4 standard but because they are not part of the POSIX standard, they should not be part of the "PosixFile" type, but rather in their own type.



== The Instance
The Instance is the main concept of the mize data engine. Everywhere some code needs to access, store or update some data an Instance will be present and the interacting with data will be done through methods of the Instance. There is a Rust struct called Instance that holds all necessary state and implements those methods in the file `./src/core/instance/mod.rs` of the mize source code.

// think some more is needed here... maybe code example

== The Namespace
Every Instance has a Namespace associated with it, which will makes it uniquely identifiable anywhere. For Instances that are more consuming data or user facing the Namespace will be a UUID. When you create an Instance and don't specifically configure some Namespace a random UUID will be generated. For Instances that are supposed to own data their domain should be used. So I will have for example one Instance, that is my home server, which is reachable from the internet under the domain "c2vi.dev" and also has the Namespace "c2vi.dev".

Additionaly to having one Namespace, an Instance can also be part of one Namespace. An Instance on my local laptop would be setup to be part of the Namespace "c2vi.dev". This would make every item stored on and owned by my homeserver Instance by default and more importantly means I address the same items across all my devices, because all my devices are part of the same Namespace.

== The MizeId
Each Item needs to be identifiable somehow. This is what the MizeId is for. It is essentially a path, but with two extra concepts.

1) The first element of the path is usually the so called "store part". It is generated by the storage part of the Mize dataengine, which can be swapped out for different implementations. Depending on the what storage part is in use and user configuration it can be just an incrementing number like github issiues, a uuid, random base64 strings like youtube videos or something like Snowflake (@BibSnowFlake) from X.com.

2) Before the first part there is the optional Namespace. It can be ommited, wehen you want to address an item on the Namespace your instance is part of. To address Items from another Namespace you add this namespace to the front of the MizeId seperated with a colon.

A MizeId without a namespace can for example look like `0/inst/config`. And one with a Namespace like `462acca5-81aa-4da2-bddc-da00d126ba9a:22/type` or `c2vi.dev:mod/youtube/dQw4w9WgXcQ/title`.

A MizeId can also be represented as a URL (@BibURL), which would use the scheme named mize, the authority part would be the namespace, then the store part as the first element behind the slash and finally rest of the path look as following: `mize://<namespace>/rest/of/path`. Parameters will be ok to be used for URL like MizeIds and even non URL MizeIds, but for now there was not yet found a use for them in the Mize data engine.


== Network of Instances
It is important for instances to be able to talk to one another, since one of the main goals of the mize platform is that any data is usable on any device just like it was local.


=== Topology
The Topology is implemented in a peer-to-peer way. An Instance can establish a connection to some other Instance using one of many transport layers like tcp, quick, websockets, ipc sockets, Bluetooth, serial, shared memory, canbus and usb through which messages about data are then exchanged.

There is however a quite hard problem that exists in such an architecture. How does an Instance know what other Instances need to know about some change in some data? What if two Instances what to update the same data at the same time? This problem gets even harder when an Instance is offline for some time. This can happen if the hardware the Instance is running on is turned off, has no power or no connection to the other instance. Systems with a distributed peer-to-peer architecture can get quite complex, because of that. There is for example the concept of CRDTs which stands for "conflict free replicated data types". CRDTS were explored for use in this project, but not used because of their complexity. The possibility to add CRDT functionality later is planned for.

Because a Server-Client architecture is so much simpler, Mize uses an architecture similar to that on top of the peer-to-peer connections. There is always one Instance that has ownership of an item, it's master Instance. With this there is always one Instance knowing the newest state of an item and all updates to an item have to eventually go through this one Instance. With the ability to send special "maybe updates" to peers directly. Such updates may then be reverted or changed by the master Instance of the Item. This is useful to display updates to the user faster, in case the master Instance is further away network wise, or if it is not reachable at all. The master Instance of an Item can also change dynamically if this is needed.

In stark contrast to the established Server-Client model, not all Items of a Namespace have to have the same master Instance. This will be useful for larger deployments where the traffic for all the Items of the Namespace would be too much for one server to handle. In such a deployment the intended Topology is as follows. There are frontend Instances that are distributed across the globe, acting as sort of a CDN. Users connect to the frontend Instance, that is geographically closest to them, which is done using the DNS System. And then there are backend Instances that are the actual master Instances of the hosted Items. Each frontend Instance has to take care of only some of the users of the service and each backend Instance has to be master of only some of the Items, or even only one Item, if necessary. No single instance has to deal with all the traffic. With this setup also services with a lot of demand should be possible.

=== Cbor
Cbor (= Concise Binary Object Representation) is a data encoding format similar to JSON, but binary instead of Text based, making it not human readable. A binary encoding scheme was chosen instead of the Text based JSON for two advantages. Firstly less overhead is added by the encoding itself and secondly it supports encoding arbitrary byte sequences. With JSON such arbitrary data sequences would be encoded into Base64 first, which further increases the size of encoded data by a third.

=== Protocol
In order to exchange data and changes to data over the connections between Instances, a protocol is needed. The protocol of the Mize Data engine works by exchanging different types of Messages between the Instances. A Message is made up of Cbor encoded bytes, that represent the Cbor type called "map". A Cbor map maps keys to values and is comparable to an Object in JSON. The value mapped by the key "1" is the Command field or the type of the message. Different types of messages then have different keys that they need. The key "2" dnotes the MizeId, that the message is about.

At the current state, where simple data excahnges can take place, only eight types of messages are implementd, as seen in `./src/core/proto.rs`
- `CMD_GET` ... sent to get the data of the item specified by the id field.
- `CMD_GIVE` ... sent in reply to a `CMD_GET` containing the data of an Item.
- `CMD_UPDATE` ... sent by the instance with ownership of an item, to tell other Interfaces about changes in that Item.
- `CMD_UPDATE_REQUEST` ... sent to request a change in an Item where the sending Instance is not the owner of.
- `CMD_SUB` ... sent to the Instance with ownership, to let it know, that you want to be notified of updates to an Item.
- `CMD_GET_SUB` ... the same as sending a `CMD_SUB` and a `CMD_GET` as seperate messages, because getting the data and subscribing to updates are often needed at the same time.
- `CMD_CREATE` ... ask an Instance to create an Item, which it will then be the owner of.
- `CMD_CREATE_REPLY` ... sent in reply to a `CMD_CREATE` containing the MizeId of the newly created Item.

The fact, that a message is just a Cbor map, makes the protocol extreamly extensible. This is by design and inspired by the HTTP Headers, which are of a similar data structure that allowed HTTP to extend it's capabilities by defining many new Headers.


=== Types of Messages



== Portability <portability>
Before commit `a16c2f92217c79445650ce1ce2e8ef6391e849c3` the implementation plan was to have one server, which was written in Rust, that would take care of storing all Items and handling updates and so on. There would then be client implementations in any language Mize can be used with. This implementation plan can be seen in older commits of the Mize repository and was already syncing data between the server and a JavaScript client implementation.

Around the above mentioned commit it was realised, that a lot of the logic is implemented twice. Once in the server and once in the client. The client for example also has to store the items even if only in ram. But it may be even desirable for it to store them on disk, to be kept across restarts. Also all the logic to update the data of items has to be reimplemented in every client language.

=== One library for all languages <oneLib>
The question then was, can a, what was since then called Instance, be written in a language, that can then be used as a library by any other language. So that this Instance code would become the server as well as the client. It turns out, that almost any programming language can somehow interact with a C library. C is a very old languagen that is still widely used today. Any language needs to call C functions from the C standard library if it wants anything from the Operating System anyway, so almost all languages have a way to call functions from a shared C Library. In Java you can for example use `System.loadLibrary("libname")` which defines special to Java exported C functions. In python there is the CDLL functioon and then you can call any normal C function of the shared library. This works the same in any language I can find.

JavaScript running under for example NodeJs can use shared C libraries in the same way as any other language, but what about JavaScript that runns in the Browser? There is a project called asm.js (@BibASMJs), which can compile C into a JavaScript, using only a subset of JavaScript's operations, expressions and functions in order to run faster. Using this we can compile our Mize Instance C Library to JavaScript and use it in the Browser. In recent years a standard called WebAssembly was developed, which allows to run C and most other compiled languages in the Browser. WebAssembly is as the name suggests an Assembly like language, a list of instructions similar to what a CPU would execute. The instructions that WebAssembly defines are however optimized to be run by a virtual machine, making it also similar to the byte code Java is compiled into, which is then run by the JVM (= Java vurtual machine). Such virtual WebAssembly machines are now part of every modern web browser.

It might seem that the logical conclusion would be that the Instance code has to be written in C, but this is not the case. It is not just easy to use C shared libraries in many languages, many languages also make it easy to make C like shared Libraries with them. Rust is one of them. In Rust a function can be declared with a special `extern "C"` and `#[no_mangle]` directives, which will make the compiler compile it in a C way. You can then also tell the Rust compiler to create a C shared library in addition to the rlib (= Rust library) file.

=== JVM languages
Languages that run in the JVM (= Java Virtual Machine, @BibJVM) like Java and Kotlin are not compiled to machine code, but to JVM byte code, which is then executed by the JVM. This enables a compiled programm to run on any system which has a JVM. JVM programms can use C like libraries, which contain machine code, through the use of the JNI (= Java Native Interface @BibJNI). This however removes the portability of JVM applications. It is possible to include multiple versions of the C library and choose the right one for the system at runtime, but this is far from a clean solution. There is a project called "Asmble" (@BibAsmble), which claims it can transpile WebAssembly Instructions to JVM bytecode. This would allow to distribute the Mize library for JVM Languages as only JVM bytecode, improving portability by a lot.


=== Cleaner Codebase
The desicion that the Rust code for the Instance should run anywhere to be uses as a library by any programming language, made it nececary to seperate the logic of the Instance itself (which will be the same no matter the environment and language) from the logic that interacts with the platform beneath, on which the Instance code runs on. Where the platform beneath could be an operating system, the browser, the hardware directly in case of embedded systems without an operating system, the JVM and many more. This restriction, that logic, that is part of the Instance can not do any direct interaction with for example the operating system, made the code a lot cleaner. All the Code that is part of the Instance logic, is in the folder `src/core` and all logic, that has to do with a particular platform is cound in `src/platform`.



= Packaging and Distributing <pkging>
Software Packaging is the process of getting all parts of a Software Application into a format, that can be used to run the Application (or use the library) on a certain user's system. Distributing is about how you then get the application or library to the user.

It is a goal of Mize to be able to run on any computer system, from large servers to laptops to microcontroller powered smardHome devices. To run Mize under Windows, Linux or MacOS it should be a simple as downloading the right executable file and running it. No installation required and it should just work. To achieve this some thought needs to go into the packaging and distributing part of Mize.

As mentioned in @oneLib, the core logic code that is written in Rust will be used everywhere and by any programming language where Mize is used. This means, that if for example someone writes a programm in python, which uses the Mize library, the machine code of the library may need to be different depending on system the python programm is executed on. Things like this and many more need to be taken into account, when thinking about how to package and distribute Mize.



== Differences between computer systems Mize should be able to run on <diff-computer-systems>
There are countless details/characteristics that can be different between a user system (also called the target system) and the system that is used to develop in this case the Mize platform. Also user systems might vary across many of said details. The software you write is only use full to the user, if it runs on whatever system the user has.

A broad summarily of such characteristics of a computer system follows.


=== OS Kernel
A kernel is the main component of an operating system and the only one that actually interacts with hardware. In order to be able to talk to hardware it needs to run with higher privilege than all other programs of the operating system and all user programs. A kernels job also includes memory management, giving device agnostic access to hardware devices, process management and file systems.

The two most used kernels are the Windows Kernel, which is the most popular option for desktop computers and Linux, the most popular option when it comes to server systems and smartphones. Two other frequently used kernels are XNU (standing for X not Unix), the one used and developed by Apple for all of their operating systems and the FreeBSD Kernel development by the FreeBSD Foundation.

The differences important for distributing our software are the apis used by user space programs to interact with the kernel, also called system calls or syscalls, and the file formats executable programs and libraries need to be in, so that their kernel can execute/load the machine code.

Another possibility that can be considered for distributing software is systems without a kernel or small micro and realtime kernels. Such scenarios are often found in embedded devices and are also called "bare metal" systems. //also talk about efi??? (NO)


==== Syscalls
A userspace program has to use syscalls to do anything that is not modifying it's own memory pages. Running another program, reading a file, using a network interface, allocating more memory, ... are all things somehow done via a syscall. In order to invoke a syscall a program has to set some CPU registers according to the syscall spec and then execute the "syscall" instruction.

Unix based kernels like Linux, FreeBSD Kernel and XNU take the approach of having a small number of syscalls and using special files and ioctls to provide all needed functionality. This comes to around 100 syscalls. The Windows Kernel has multiple thousands of syscalls and they can change with every release of Windows. Unix kernels keep their syscalls the same forever, or at least stay backwards compatible by only adding extra ones.


==== File Formats
The file containing the executable code we distribute has to be in the right format for the kernel to load it into memory and start executing it as a new process or a dynamic library.

The Executable Linkable Format (= ELF) is what used by Linux and FreeBSD kernels. Windows and the former DOS have the Portable Executable format and the Apple kernel uses a file format called Mach-O.


=== CPU architecture
The CPU architecture defines what instructions a CPU can execute and how they need to be structured. Common examples for CPU architectures are x86, arm, avr and riscv, but many more exist.


=== OS userspace
Windows solves their ever changing syscalls by providing system libraries like for example kernel32.dll and user32.dll, which programs should use to interact with the kernel. Also when using Unix kernels syscall aren't invoked by your code directly, there is a so called "standard library" for that. Besides having functions, that directly call syscalls standard libraries also have a lot of functionality that makes interacting with the kernel more friendly. Multiple of such standard libraries exist. The most used one is glibc, made as part of the GNU project. Others are Musl, bionic, newlib and some more.

Userspace wise Windows makes it easy for us, as there is only one Userspace. Linux however has over 1000 different distributions. Some are very similar, like Debian and Ubuntu and some do things completely differently, like Android or NixOS.


// write about linking with different dlls depending on GUI or cl application (ahm NOPE.... xD)
// A special thing about the Windows userspace is that our binary needs to link with a different dll  ... actually i don't know enough about that..

// there are systems, that don't have dynamic linking at all

=== Available Hardware and Drivers
On some systems there will be special hardware for example rendering graphics or decoding a video stream. Our software should take advantage of that if available.



== Implementing the distributing part
Now that we know what all needs to be taken into account for the packaging of this project, the following paragraphs document the implementation of the distributing and packaging part of Mize.


=== Cross Compiling
Cross Compiling is the process of building software that should run on a computer system that is different, in regards to one or more of the characteristics mentioned in @diff-computer-systems, to the system used to compile the software.

Copying the source code of mize onto every system we want to release for and build it on there, is just not practical. That would require to have one of every kind of system and take way too long. So cross compiling is certainly a thing we need to implement into the distributing process. Cross compiling usually means installing some sort of cross toolchain and running that to compile the source code. Every system we want to compile for, will of course need it's own toolchain installed. This imperative approach firstly takes a lot of manual effort and seccondly it often happens, that all the installed cross toolchains and also toolchain local to the system interfere with one another, which can produce unexpected errors during compelation. Those errors then have nothing todo with something being wrong in any of the compiled source code, but rather in the toolchains and how they were installed.


=== Nix
Nix is the name of a package manager and a domain specific language, that is used by this package manager to define packages.

The first major difference to most other package managers is that a package is not defined as a set of attributes like the version, the name, list of dependency packages. With Nix however a package is a function in this Nix language. The parameters of this function are, every dependency, compilation options, the compiler and many "build functions" special to the targeted system and the language of the project. The functions that defines a package then calls one of those "build functions" passing it things like name, version, source-code and other metadata of the package.

With most package managers apart from Nix a package defines the path it is installed into. The package manager simply runs the install code of the project using for example `make install` for make based projects. This method leads to a significant problem when you'd want to install two different versions of a package, both versions will want to install files to the same path. The Nix package manager installs a package only into a path that is unique to that package. Such a path looks for example like this: `/nix/store/<hash>-<name>-<version>/`, where `<hash>` is a hash of all used "inputs" (the arguments passed to "build functions"), therefore being only the same if you install a package with exactly matching dependencies, compiler options, target system, and so on.

=== How Nix helps with cross compiling
Nix runs all builds in a sandboxed environment, where only the needed programms, dependencies and toolchains are installed. This fully eliminates errors that arise because of the toolchain, how it is installed or interferences with other installed toolchains or programms. All the details off this sandboxed environment and what toolchain and dependencies are installed is declaratively defined in the package definitions using the Nix DSL. It is also worth noting, that nix uses hashing, to make sure to use exactly the same exact versions of toolchain, dependencies, programs, making those environments fully repoducible.


//=== The Module System
//add maybe


=== The distributing process
After the nix definitions are written, it becomes possible to run one command, that builds all versions of mize and all modules for all computer systems. The command is `nix build github:c2vi/mize#dist` and can be run on any Linux system, with the only thing, that needs to be installed being Nix. This creates a path in the Nix store, which can then simply be rsyncd onto a webserver, where users can download the correct executables and other files. There is a shell script in the mize repository called "deploy", which does basically that and also checks, if the path is succesfully created by the nix build invocatikon with `[[ "$path" != "" ]]` and only then runns the rsync command.

```
path=$(nix build .#dist -L -v --print-out-paths $@)
[[ "$path" != "" ]] && rsync -rv $path/* ocih:host/data/my-website --rsync-path="sudo rsync"
```




