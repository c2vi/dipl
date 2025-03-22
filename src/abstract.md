
## Abstract

This thesis is about the planning the data enginge called Mize, which is part of a larger software paltform with the same name. In the beginning already existing data engine systems and software platforms with similar capabilities are examined, which leads to the conclusion, that nothing that fully matches the requirements of the Mize data engine exists. The main goals of mize are, to make data accasible as if it were stored locally on the device, even if it is not and give this access through one simple and universal API, like Filesystems did, back when multiple devices per user were not a thing yet.

To achieve this mize has a struct called an Instance, through wich all data can be accesed and also modified. Each place data is needed, there is an Instance. They all can talk to one another in a Peer-to-Peer way with one Instance being the owner of every peace of data, to be able to correctly coordinate multiple changes to the data from multiple sources in a simple way. This instance is implemented with the programming langugage Rust and compiled in different ways, to form libraries, that can be used by any programming language and run on any computer system. For that the packaging part of mize also makes up a part of this thesis.

In addition to planning the mize data engine, a MVP of it is also implemented, to show that the core planned concpets can work.


## Kurzfassung

Die vorliegende Diplomarbeit beschäftigt sich mit der Planung von der Daten Engine mit dem Namen Mize, und darum herum einer Software Platform mit dem gleichen Namen. Am Anfang werden Daten Engines und Platformen mit ähnlichen Fähigkeiten untersucht, was zum Schluss führt, das es nichts gibt, was komplett mit den Anforderungen der Mize Daten Engine übereinstimmt. Die Hauptziele von Mize sind Daten abrufbar zu machen als ob sie lokal auf dem jeweiligen Gerät sind, auch wenn sie das nicht sind und das über eine einfache und universelle API, so wie Filesysteme das waren zu Zeiten, wo es mehrere Geräte pro Benutzer noch nicht gegeben hat.

Um das zu erreichen hat Mize eine Strukture mit dem Namen Instanz, durch welche alle Daten abrufbar und modifizierbar sind. Überall wo Daten gebraucht werden ist eine solche Instanz. All diese Instanzen können mit dem Peer-to-Peer prinzip miteinander reden, wobei eine Instanz immer der Inhabervon einem Datenstück ist. Dies macht es möglich eine korekte koordinierung von mehreren Änderungen der Daten von mehreren Quellen einfach zu gestalten. Diese Instanz ist mit der Programmiersprache Rust implementiert und kompeliert in unterschiedlichen wegen um software Bibliotheken zu erhalten, welche von jeder Programmiersprache verwendet werden können und auf jedem Computer System ausgeführt werden können. Daher macht der Packetierungs Teil von Mize auch einen Teil dieser Arbeit aus.

Zusätzlich zur Planung der Mize Daten Engine wurde auch ein MVP davon implementiert, um zu zeigen, dass die Kernkonzepte funktionieren können.


## Project outcome
All core concpets of the Mize data engine are planned, thought out and documented in this thesis. The MVP implementation can make data accesible as if it were local across Instances on the same Linux system connected throught Unix Sockets. The connection into the webview of the Mize Explorer is implemented, but not fully working yet. The connection using Websockets is not yet implemented. With the invokation of one command Mize can be compiled for Linux x86_64, Linux aarch64, WebAssembly for running in browsers and Windows x86_64 and then automatically uploaded to a public http serer.







