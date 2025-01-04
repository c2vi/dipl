
This chapter describes the system used for writing the document of the diploma thesis, as it is not as straight forward as using Microsoft Office.

To generate the final document, the Latex template that is provided by the school is used. However because Latex is annoying to write and Latex source code confusing to look at, other options, that could still use the Latex template were examined.

= Markdown
Markdown is a lightweight markup language, that was specifically made, to be pleasing to look at and use in a plain text editor. There is a tool called pandoc, which converts between all kinds of Document formats and also supports a conversion from Markdown to pdf, using a Latex template.

The Problem with Markdown is, that it has no means for a reference to another section, or a way to link to sources.

= Typst
Typst is a Markup language very similar to Markdown, but was made for building documents with it. So it has ways of linking to other sections and sources. Pandoc also supports conversion from Typst to latex code which can then be made into a pdf using our template.


= The htldoc tool

== Usage of Nix
- to get working pdflagex pkgs on every distro
- for the configuration of the htldoc tool

== Getting configuration options from htldoc.nix into the Latex template


== The Generate Listing Subcommand

=== Use of an LLM to generate the core logic for this script
The prompt:
```
can you write a python script, which takes as it's first argument the path to a git repository and then goes through all commits of a predefined branch starting from a predefined commit and for each one runns a predefined command which would generate a pdf file. this pdf should be copied to a predefined folder. then also it generates a html file serving as the index over all the pdf files showing the commit hash, link to the github repo of this commit, date of the commit. commits in this list should be ordered by date.
```

with two relevant follow up changes:
```
can you refactor, so that the configuration comes from a json string, that gets passed to --config
```

```
can you make it so, that in the html file only commits, where the pdf changed, is included
```

the full conversation can be found here: https://chatgpt.com/share/6776bc6b-9824-800e-bb77-120111ab6bab



