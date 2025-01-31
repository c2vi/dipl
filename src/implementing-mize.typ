

// to the implementing of mize


= Packaging and Distributing <idea-of-mize>

== What is Software Packaging
Software Packaging is the process of getting all parts of a Software Application into a format, that can be used to run the Application (or use the library) on a certain user's system.



== Differences between computer systems this project should be able to run on
There are countless details/characteristics that can be different between a user system (also called the target system) and the system that is used to develop in this case the Mize platform. Also user systems might vary across many of said details. The software you write is only usefull to the user, if it runs on whatever system the user has. For the Mize platform it is a goal to eventually run on any computer system as seen in @idea-of-mize

A broad sumary of such characteristics of a computer system follows.

=== OS Kernel
A kernel is the main component of an operating system and the only one that actually interacts with hardware. In order to be able to talk to hardware it needs to run with higher priviledges than all other programs of the operating system and all user programs. A kernels job also includes memory management, giving device agnostic acces to hardware devices, process management and filesystems.

The two most used kernels are the Windows Kernel, which is the most popular option for desktop computers and Linux, the most popular option when it comes to server systems and smartphones. Two other frequently used kernels are XNU (standing for X not Unix), the one used and developed by Apple for all of their operating systems and the FreeBSD Kernel developement by the FreeBSD Foundation.

The differences important for distributing our software are the apis used by userspace programs to interact with the kernel, also called system calls or syscalls, and the file formats executable programms and libraries need to be in, so that ther kernel can execute/load the machine code.

Another possibility that can be considered for distributing software ist systems without a kernel or small micro and realtime kernels. Such szenarios are often found in embedded devices and are also called "bare metal" systems. //also talk about efi???


==== Syscalls
A userspace program has to use syscalls to do anything that is not modifying it's own memory pages. Running another program, reading a file, using a network interface, allocating more memory, ... are all things somehow done via a syscall. In order to invoke a syscall a program has to set some cpu registers acording to the syscall spec and then execute the "syscall" instruction.

Unix based kernels like Linux, FreeBSD Kernel and Xnu take the approach of having a small number of syscalls and usind special files and ioctls to provide all needed functionality. This comes to around 100 syscalls. The Windows Kernel has multiple thousands of syscalls and they can change with every release of Windows. Unix kernels keep their syscalls the same forever, or at least stay backwards compatiple by only adding extra ones.


==== File Formats
The file containing the executable code we distribute has to be in the right format for the kernel to load it into memory and start executing it as a new process or a dynamic library.

The Executable Linkable Format (= ELF) is what used by Linux and FreeBSD kernels. Windows and the former DOS have the Portable Executable format and the Apple kernel uses a file format called Mach-O.


=== CPU architecture
The CPU architecture defines what instructions a CPU can execute and how they need to be structured. Common examples for CPU architectures are x86, arm, avr and riscv, but many more exist.


=== OS userspace
Windows solves their everchanging syscalls by providing system libraries like for example kernel32.dll and user32.dll, which programs should use to interact with the kernel. Also when using Unix kernels syscall aren't invoked by your code directly, there is a so called "standard library" for that. Besides havind functions, that directly call syscalls standard libraries also have a lot of functionality that makes interacting with the kernel more friendly. Multiple of such standard libraries exist. The most used one is glibc, made as part of the GNU project. Others are Musl, bionic, newlib and some more.

Userspace wise Windows makes it easy for us, as there is only one Userspace. Linux however has over 1000 different distributions. Some are very similar, like Debian and Ubuntu and some do things completely differently, like Android or NixOS.


// write about linking with different dlls depending on gui or cli application
// A special thing about the Windows userspace is that our binary needs to link with a different dll  ... actually i don't know enought about that..

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

```bash
path=$(nix build .#webfiles -L -v --print-out-paths $@)

[[ "$path" != "" ]] && rsync -rv $path/* ocih:host/data/my-website --rsync-path="sudo rsync"
```


== Development Setup
#include "./dev-environment.typ"



== The Module System





= The Data engine
//- As already said in (TODO: link to idea-of-mize), a way to manage data is the basis of any software project.

//- and in #link("hist") previous attempts at implementing a generla solution for that data management were examined.

  //- incoperating all the learnings from that... we now look at the latest implementation attempt, that will hopefully stand the test of time.

== Topology


=== How it's implemented
// talk about how from a theoretical standpoint and how it's implemented is peer-to-peer connections of instances



=== Practically Speaking...
// TODO: better title

// talk about how you would from a practical standpoint


== Portability


//Before this commit: a16c2f92217c79445650ce1ce2e8ef6391e849c3 mize would be a server, and have client implementations in many languages. Most importantly js for the browser, Python for quick programs and C for a small embedded client for uCs.

//The thing with this approach is, that you would have a lot of functionality (eg the one for updating items) implemented multiple times, across the server and all client-implementations.

//- explain the new layout of the mize project

== Instance
// what is an instance.... what are it's jobs


== Protocol

=== Cbor
Cbor (= Concise Binary Object Representation) is a data encoding format similar to JSON, but binary instead of Text based, making it not human readable. A binary encoding scheme was chosen above the Text based JSON for two advantages. Firstly less overhad is added by the encoding itself and secondly it supports encoding arbitrary byte values. With JSON such arbitrary data values would be encoded into Base64 frist, which further increases the size of encoded data by a third.


=== A Message
Cbor has a data type called map, that is just like a json object.


// how a message looks like ... that it's very extensible like that

// what message types exist till now

=== Types of Messages


== Update coersion
// the concept that one instance is responsible for an item ... with OT

// future plans of an crdt impl...




= The Gui engine


== A segfault because of webkitgtk
#include "./webkitgtk-regression.typ"



= The Command engine




