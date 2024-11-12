
This chapter shortly describes the developement setup used for developement on Mize.

= NixOS

= Neovim

== Neovim for writing the documentation
As described in (TODO link to the doc-system chapter) the documentation is written in the language Typst and with the editor Neovim. For that some configuring of Neovim is needed, as it does not have builtin support for the typst language. For this the #link("https://github.com/c2vi/nixos/blob/162e1590b399810bd242bed71a6d0b3c1daac21b/programs/neovim.nix", [neovim.nix file of my nixos configuration]) is changed as follows.

There is a language server project (TODO: Footnote language server) for typst on #link("https://github.com/nvarner/typst-lsp", [github]), which is also already packaged in nixpkgs (TODO footnote) #link("https://github.com/NixOS/nixpkgs/blob/76612b17c0ce71689921ca12d9ffdc9c23ce40b2/pkgs/by-name/ty/typst-lsp/package.nix", [here]). So it can be added as a lsp programm for the COC (TODO footnote) lsp (TODO footnote) client. Also the filetypes for which this lsp should be used need to be defined. This is done as seen in this #link("https://github.com/c2vi/nixos/commit/1a9b1c81fd4b0a0d499a92f7f108bdbadc7ad168", [commit]).

Syntax highlighting does however not work with this lsp, so also the typst.vim vim extension from #link("https://github.com/kaarmu/typst.vim/", [this github repo]) is added, which is also packaged in nixpkgs (TODO footnote) #link("https://github.com/NixOS/nixpkgs/blob/76612b17c0ce71689921ca12d9ffdc9c23ce40b2/pkgs/applications/editors/vim/plugins/generated.nix", [here]). So it's simply added to the `programs.vim.plugins` option as seen in #link("https://github.com/c2vi/nixos/commit/cb864f0f5ed3b37eeb7fe8fe4627379a89bc161d", [this commit])







