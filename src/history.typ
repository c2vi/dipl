
The Idea of Mize was everything but immediate, it evolved over about 4 years. First thoughts about something like that came to mind shortly after learning to programm with python in first class of the HTL. This history is documented in this chapter.

= Coding Wiki
When learning to code I ran into the problem, that you forget all the names of functions, modules, concepts and even the names of keywords. And also what they do. So to help with that I wanted to make an application, where I could put all those things and be able to look them up, when needed by searching. All those items would have a type, eg: keyword, python-imternal-function, python-module, .... Later I realised, that also all "documentation items" from other languages and frameworks could be added to such a searchable system and work on a "personal db" was also started, where personal notes, quotes and anythinge else could be stored and would have a type of what it is, like note, quote, date and so on.

The implementation of this predecessor of Mize, never become close to being usable. I gave up when I couldn't get html forms to work, this was a struggle due to a lack of understanding for HTTP and networking in general. The source code was later uploaded to github for the purpose of documenting the history of Mize.


= Items Project
This next iteration already had the concept of an Item, which has a certain type, which was reflected in it's name. The realisation in this iteration was, that every peace of data could be represented as a JSON document, even for a file, you could encode it's contents with Base64 and have that stored with also the metadata of the file in a JSON document. So the plan was to make a webapp, as that was the new thing i learned just then, that could show JSON documents using different React Components depending on the `_type` field of the document. The backend was a server also written in JavaScript, who talked to a MongoDB database where the JSON documents were stored.

This project was already able to show all the Moodle courses, in which a Moodle account was a member in, with it's own GUI, but the implementation was not future proof at all. Also the requirement to have a working MongoDB somewhere to setup Mize was annoying, I wanted to just be able to run an executable, which would also handle all the storing of data and not require any external services.

= Mize
For the third iteration I thought, that to make something proper, it would need to be implemented in a lower level langauge. So initially C was concieved, but then I found and learned Rust, which turned out to be a great language choiche for this project, also because of it's memory safty guarantes at compile time (@BibRustMemorySaftey). The goal was to refine the ideas from the Items Project and implement them in a proper way, that would also be future proof, extensible and have a simple core with many addon modules for all extra functionality.

Initially the messages of the protocoll had a custom encoding logic, where the interpretation of each byte was hardcoded into the decoding function. The plan with this was to save bandwith, because we don't have the overhead of JSON. This turned out to be a stupid idea, as a value of type u64 (@BibRustU64) with a value of 1 was encoded as a 1 with seven 0 bytes following. After realising this, at commit `9825c5242b7a71bbd119e83af95b2f77af16571f` the messages were switched to be simple JSON documents.

The next big change of Mize was the focus on portability, which is explained in more detail in @portability, as it is already in the timeframe of the diploma thesis. This also facilitated the change of the protocoll's encoding to Cbor.


