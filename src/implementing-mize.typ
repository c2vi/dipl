

// to the implementing of mize


= Packaging and Distributing <idea-of-mize>

== What is Software Packaging
Software Packaging is the process of getting all parts of a Software Application into a format, that can be used to run the Application (or use the library) on a certain user's system.



== Differences between computer systems this project should be able to run on
There are countless details/characteristics that can be different between a user system (also called the target system) and the system that is used to develop in this case the Mize platform. Also user systems might vary across many of said details. The software you write is only use full to the user, if it runs on whatever system the user has. For the Mize platform it is a goal to eventually run on any computer system as seen in @idea-of-mize

A broad summarily of such characteristics of a computer system follows.


=== OS Kernel
A kernel is the main component of an operating system and the only one that actually interacts with hardware. In order to be able to talk to hardware it needs to run with higher privilege than all other programs of the operating system and all user programs. A kernels job also includes memory management, giving device agnostic access to hardware devices, process management and file systems.

The two most used kernels are the Windows Kernel, which is the most popular option for desktop computers and Linux, the most popular option when it comes to server systems and smartphones. Two other frequently used kernels are XNU (standing for X not Unix), the one used and developed by Apple for all of their operating systems and the FreeBSD Kernel development by the FreeBSD Foundation.

The differences important for distributing our software are the apis used by user space programs to interact with the kernel, also called system calls or syscalls, and the file formats executable programs and libraries need to be in, so that their kernel can execute/load the machine code.

Another possibility that can be considered for distributing software is systems without a kernel or small micro and realtime kernels. Such scenarios are often found in embedded devices and are also called "bare metal" systems. //also talk about efi???


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


// write about linking with different dlls depending on GUI or cl application
// A special thing about the Windows userspace is that our binary needs to link with a different dll  ... actually i don't know enough about that..

// there are systems, that don't have dynamic linking at all

=== Available Hardware and Drivers
On some systems there will be special hardware for example rendering graphics or decoding a video stream. Our software should take advantage of that if available.



== Implementing the distributing part
Now that we know what all needs to be taken into account for the packaging of this project, this chapter documents the implementation of the distributing and packaging part of the Diploma Thesis.


=== Nix
Nix is the name of a package manager and a domain specific language, that is used by this package manager to define packages.

The first major difference to most other package managers is that a package is not defined as a set of attributes like the version, the name, list of dependency packages. With Nix however a package is a function in this Nix language. The parameters of this function are, every dependency, compilation options, the compiler and many "build functions" special to the targeted system and the language of the project. The functions that defines a package then calls one of those "build functions" passing it things like name, version, source-code and other metadata of the package.

With most package managers apart from Nix a package defines the path it is installed into. The package manager simply runs the install code of the project using for example `make install for make based projects`. This method leads to a significant problem when you'd want to install two different versions of a package, both versions will want to install files to the same path. The Nix package manager installs a package only into a path that is unique to that package. Such a path looks for example like this: `/nix/store/<hash>-<name>-<version>/`, where `<hash>` is a hash of all used "inputs" (the arguments passed to "build functions"), therefore being only the same if you install a package with exactly matching dependencies, compiler options, target system, ....

// one absatz to why nix is used

=== Cross Compiling



=== The distributing process

// the uploading to my file server

//```bash
//path=$(nix build .#webfiles -L -v --print-out-paths $@)
//
//[[ "$path" != "" ]] && rsync -rv $path/* ocih:host/data/my-website --rsync-path="sudo rsync"
//```


//== Development Setup
//#include "./dev-environment.typ"




=== The Module System





= The Data engine
//Previous attempts at making a general data management solution were looked at in @hist.

This chapter is about the implementation of the so called "Data engine" that will form the basis of the mize platform. 


// nope .. As already said @idea-of-mize a way to manage data is the basis of any software project. This chapter looks at the implementation

//- As already said in (TODO: link to idea-of-mize), a way to manage data is the basis of any software project.

//- and in #link("hist") previous attempts at implementing a general solution for that data management were examined.

//- incoperating all the learnings from that... we now look at the latest implementation attempt, that will hopefully stand the test of time.

== The Item
Each bit of data is called an Item in this data engine. An Item works much like a mixture of the well established data storage concepts File and Folder. Files hold a list of bytes and Folders hold a list of links to other files. An Item has both a list of bytes, a list of links to other items and also a type.

=== The Type System
In an ordinary filesystem the type of the data in a file is defined by the string after the last dot or by the first few bytes of the file being a "magic value". An Item of the Mize data engine always has a type associated with it. // NEXT write smth else here... how the type system will work



== The Namespaces


== The MizeId


== The Instance
The Instance is the main concept of the mize data engine. Everywhere some code needs to access, store or update some data an Instance will be present and the interacting with data will be done through methods of the Instance. There is a Rust struct called Instance that holds all necessary state and implements those methods in the file `./src/core/instance/mod.rs` of the mize source code.

// think some more is needed here... maybe code example


== Network of Instances
It is important for instances to be able to talk to one another, since one of the main goals of the mize platform is that any data is usable on any device just like it was local.




=== Topology
The Topology is implemented in a peer-to-peer way. An Instance can establish a connection to some other Instance using one of many transport layers like tcp, quick, websockets, ipc sockets, Bluetooth, serial, shared memory, canbus and usb through which messages about data are then exchanged.

There is however a quite hard problem that exists in such an architecture. How does an Instance know what other Instances need to know about some change in some data? What if two Instances what to update the same data at the same time? This problem gets even harder when an Instance is offline for some time. This can happen if the hardware the Instance is running on is turned off, has no power or no connection to the other instance. Systems with a distributed peer-to-peer architecture can get quite complex, because of that. There is for example the concept of CRDTs which stands for "conflict free replicated data types". CRDTS were explored for use in this project, but not used because of their complexity. The possibility to add CRDT functionality later is planned for.

Because a Server-Client architecture is so much simpler, Mize uses an architecture similar to that on top of the peer-to-peer connections. There is always one Instance that has ownership of an item, the master Instance. With this there is always one Instance knowing the newest state of an item and all updates to an item have to eventually go through this one Instance. With the ability to send special "maybe updates" to peers directly. Such updates may then be reverted or changed by the master Instance of the Item. This is useful to display updates to the user faster, in case the master Instance is further away network wise, or if it is not reachable at all. The master Instance of an Item can also change dynamically if this is needed.

In stark contrast to the established Server-Client model, not all Items of a Namespace have to have the same master Instance. This will be useful for larger deployments where the traffic for all the Items of the Namespace would be too much for one server to handle. In such a deployment the intended Topology is as follows. There are frontend Instances that are distributed across the globe, acting as sort of a CDN. Users connect to the frontend Instance, that is geographically closest to them, which is done using the DNS System. And then there are backend Instances that are the actual master Instances of the hosted Items. Each frontend Instance has to take care of only some of the users of the service and each backend Instance has to be master of only some of the Items, or even only one Item, if necessary. No single instance has to deal with all the traffic. With this setup also services with a lot of demand should be possible.


== Portability

// this is the best thing ever done, because it separates the application logic of the mize instance... from the logic that interacts with the system the instance is running on

//Before this commit: a16c2f92217c79445650ce1ce2e8ef6391e849c3 mize would be a server, and have client implementations in many languages. Most importantly js for the browser, Python for quick programs and C for a small embedded client for uCs.

//The thing with this approach is, that you would have a lot of functionality (eg the one for updating items) implemented multiple times, across the server and all client-implementations.

//- explain the new layout of the mize project


== Protocol


=== Cbor
Cbor (= Concise Binary Object Representation) is a data encoding format similar to JSON, but binary instead of Text based, making it not human readable. A binary encoding scheme was chosen instead of the Text based JSON for two advantages. Firstly less overhead is added by the encoding itself and secondly it supports encoding arbitrary byte sequences. With JSON such arbitrary data sequences would be encoded into Base64 first, which further increases the size of encoded data by a third.


=== A Message
Cbor has a data type called map, that is just like a JSON object, mapping keys to values. 


// how a message looks like ... that it's very extensible like that

// what message types exist till now

=== Types of Messages


== Update coercion
// the concept that one instance is responsible for an item ... with OT

// future plans of an CRDT impl...




= The GUI engine


== A segfault because of webkitgtk
#include "./webkitgtk-regression.typ"



= The Command engine




