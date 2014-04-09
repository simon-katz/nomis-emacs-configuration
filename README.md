# nomis-emacs-configuration

Simon Katz's Emacs init.

This repository contains both `.emacs` stuff and `.emacs.d/` stuff.

Why combine `.emacs` stuff and `.emacs.d/` stuff in a single repo?
Although this stuff would download `.emacs.d/` stuff if it didn't exist,
that's a recipe for not knowing what versions of packages you have and
having different versions if you download packages at different times
or on different machines. That's caused me problems.

Contents:

* `make-emacs-installation.sh`

    A script to download packages in to `.../emacs-installation/.emacs.d/`

* `run-emacs-installation.sh`

    A script to run Emacs. (You can run this Emacs config without having to set up .emacs and .emacs.d in your home directory.)
    
* `.../emacs-installation/.emacs`

    My `.emacs`. This loads other stuff.

* `.../emacs-installation/.emacs.d/`

    My .emacs.d stuff.

* `.../emacs-installation/dot-emacs-stuff/`

    My `.emacs` stuff.

    * `.../emacs-installation/dot-emacs-stuff/for-anyone/`

        A directory containing things that are probably good for anyone to use.

    * `.../emacs-installation/dot-emacs-stuff/for-me/`

        A directory containing things that may not be good for
          anyone other than me to use, either because they are crap or
          because they may change significantly or because I haven't
          decided yet that they're ok. Of course, you can copy
          anything you want or use what's here as a source of ideas.

To use:

* Browse, see what's here, copy stuff and modify it.

or:

* Really use it:

    * Either:
  
        * Run `run-emacs-installation.sh`
        
        or 
        
        * Install this as your real Emacs configuration:
            * Create a symbolic link from `~/.emacs.d` to `.../emacs-installation/.emacs.d/`.
        
            and


            * Create a symbolic link from `~/.emacs`   to `.../emacs-installation/.emacs`.
