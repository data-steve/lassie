lassie
============

![](https://pbs.twimg.com/media/A-vpCIUCIAA0EjS.jpg)

Famous pooch Lassie was always there to help Timmy get help with whatever problem he was facing. No matter what Timmy said, Lassie always understood what kind of help was needed and how to ask for it. 

The **lassie** package strives to give R users the same kind of support in finding help for their R needs, by 
- Auto-searching for help on StackOverflow, Github, or Google 
- Auto-templating and posting well-formed questions to StackOverflow, if search didn't help. 


Example
============

```r
# common error for those coming from python
lassie::get_help("S"*6)
```


Installation
============


To download the development version of **lassie**:

Download the [zip
ball](https://github.com/steventsimpson/lassie/zipball/master) or [tar
ball](https://github.com/steventsimpson/lassie/tarball/master), decompress and
run `R CMD INSTALL` on it, or use the **pacman** package to install the
development version:

    if (!require("pacman")) install.packages("pacman")
    pacman::p_load_gh(
        "jennybc/reprex",
        "steventsimpson/lassie"
    )



Contact
=======

You are welcome to:     
- submit suggestions and bug-reports at: <https://github.com/steventsimpson/lassie/issues>
- send a pull request on: <https://github.com/steventsimpson/lassie/issues>      
- compose a friendly e-mail to: <steven.troy.simpson@gmail.com>     



