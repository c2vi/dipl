
This chapter describes the system used for writing the document of the diploma thesis, as it is not as straight forward as using Microsoft Office.

To generate the final document, the Latex template that is provided by the school is used. However because Latex is annoying to write and Latex source code confusing to look at, other options, that could still use the Latex template were examined.

= Markdown
Markdown is a lightweight markup language, that was specifically made, to be pleasing to look at and use in a plain text editor. There is a tool called pandoc, which converts between all kinds of Document formats and also supports a conversion from Markdown to pdf, using a Latex template.

The Problem with Markdown is, that it has no means for a reference to another section, or a way to link to sources.

= Typst
Typst is a Markup language very similar to Markdown, but was made for building documents with it. So it has ways of linking to other sections and sources. Pandoc also supports conversion from Typst to latex code which can then be made into a pdf using our template.


= The htldoc tool
