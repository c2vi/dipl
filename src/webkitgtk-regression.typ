
somewhere between nixpkgs:ea6033ce4ddf2c0ede2ea147a450d4f880796128 and nixpkgs:b9562c824b11473587286eb499680129c2d0d4f1 the webkitgtk has a regression and crashes

and produces a core dump
- how is the producing of the core dump started???
- where does the core file go???

- the call stack ends up in the systemd-journald logs so with `sudo journald -f` and then running my program captured it


rel: webkitgtk-crash in /img and /assets
