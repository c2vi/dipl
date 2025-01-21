

// to the implementing of mize


= Packaging and Distributing <idea-of-mize>
// hmmm don't know yet what to write here


== Differences between computer systems
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

=== OS Userspace

Windows solves their everchanging syscalls by providing system libraries like for example kernel32.dll and user32.dll, which programs should use to interact with the kernel. Also when using Unix kernels syscall aren't invoked by your code directly, there is a so called "standard library" for that. Besides havind functions, that directly call syscalls standard libraries also have a lot of functionality that makes interacting with the kernel more friendly. Multiple of such standard libraries exist. The most used one is glibc, made as part of the GNU project. Others are Musl, bionic, newlib and some more.



=== Available Hardware

== What is Software Packaging
Software Packaging is the process of getting all parts of a Software Application into a format, that can be used to run the Application (or use the library) on a certain user's system.


== Nix

=== What is Nix?

== Cross Compiling

=== Why Nix was chosen


== Development Setup
#include "./dev-environment.typ"




== The Module System





= The Data engine
//- As already said in (TODO: link to idea-of-mize), a way to manage data is the basis of any software project.

//- and in #link("hist") previous attempts at implementing a generla solution for that data management were examined.

  //- incoperating all the learnings from that... we now look at the latest implementation attempt, that will hopefully stand the test of time.

== Portability

//Before this commit: a16c2f92217c79445650ce1ce2e8ef6391e849c3 mize would be a server, and have client implementations in many languages. Most importantly js for the browser, Python for quick programs and C for a small embedded client for uCs.

//The thing with this approach is, that you would have a lot of functionality (eg the one for updating items) implemented multiple times, across the server and all client-implementations.

//- explain the new layout of the mize project



= The Gui engine

== A segfault because of webkitgtk
#include "./webkitgtk-regression.typ"



= The Command engine
