.onLoad <- function(libname, pkgname) {

  ata_boy <- c("Lassie says,                      ", "                    ------------- ",
               "                   /  I'm here   \\   ", "                   |  to help!   |        __ ",
               "             /|/    \\___     ___/     .--'\"`__`", "            / |-.,,____   \\/        |--'\"`__`",
               "         __/|  ~   ___/           |--'\"`__`", "     ..\"\"_ |     ____/            -'\"``",
               "     ..\"\"_|       |  __,.\"`__,'  \\", "     ..\"\" ,\\   ,\\,.\"`  ,         `:",
               "          \\ :,; `: \\`: :          \\", "          :    ` | | '     '    '  :",
               "          |   ^.  |      '          \\", "          :  ;',   ;_,.\"\"`.  \\    `;",
               "          |  ; :   |       '  `, : ;`", "          : ;   ; |          /;  ' /",
               "          ||    | |        //    /;", "          ||    || ctr   ,;    ;/",
               "          \"     \"       \"     \"")

  lassie_ata_boy <- function(){
    cat(paste(ata_boy, collapse="\n"))
  }

  lassie_ata_boy()


}
# edited from http://www.ascii-art.de/ascii/def/dogs.txt
