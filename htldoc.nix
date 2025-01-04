
# this is a config file for a diploma thesis, that is built with the htldoc tool
# this tool can be found on https://github.com/c2vi/htldoc
# a list of all options, that can be set here can be found on https://github.com/c2vi/htldoc/blob/main/diplomarbeit/options.md

{ ... }: {
  template = "dipl";

  # the options you HAVE to change
  ###############################################

  title = "MiZe - A Software Ecosystem";

  subtitle = "";

  institute = "Elektronik und Technische Informatik";

  submissionDate = "2024-12-24";

  authors = [ "Sebastian Moser" ];

  supervisors = [ "SUPERVISOR 1" ];

  # here you define all the chapters of the document
  # this is, because typst and markdown don't have chapters so tha \chapter{} is added by htldoc
  # you therefore must not add a \chapter in your tex src files
  # the order of chapters and files in a chapter is kept like how it's defined here
  # filenames are relative to the ./src folder, subfolders work
  chapters = [
    [ "History of Mize" "history.typ" "hist" ]
    [ "Documentation System" [ "doc-system.typ" ] "docSys" ]
  ];


  # some other usefull options
  ###############################################

  partner = "";

  subject = "";

  keywords = [];

  lang = "ngerman";

  draftMode = false;

  twoSidePrinting = true;

  htldocVersion = "github:c2vi/htldoc/master"; # can be used to pin a specific version of htldoc

  #htldocVersion = "/home/me/work/diplomarbeit/sebastian/htldoc";

  htldocBuildDir = "./build"; # where to put build artefacts into




  genListing.startCommit = "c6894ab047f0b8a21cf4aa9e44a0406f7e9d98c9";
}

