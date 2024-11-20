
A Mono-Repository seems like the best solution....


The packaging part of how it is now (https://github.com/c2vi/mize/commit/7033cc7e3b932939e4ff6ce55bf65b98615040a3) is quite problematic
- it's complex to know what's going on
- after a month (the basisausbilding at the ÖBH) of not working on it.... it takes some time to get all things setup again to continiue development
   - so imagine how newcomers would struggle here

== The Referencing problem

Because it's the same code running on all platforms, there are multiple package managers involved. Cargo obviosly for rust, then npm to publish mize as a npm package to npm.org and nix, to fully build everything. Flakes can reference Github repos, so can cargo and npm. So when building mize i once had id like follows: the mme module was referenced from github with a flake input, this has mize as a cargo dependency, which pointed to the mize github repository. The mme module also needed a js version of mize which was from the npm repository. So there were 3 different versions of the same code in one build.

A Mono-Repository would solve this, because cargo, nix and npm could then just have ../path/to/mize as the dependency.



