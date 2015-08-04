akop
====

AKOP (Angular Kit Of Parts) is intended to be a set of directives and other useful bits that can be selectively
integrated into your angular projects.

# Usage

To use simply drop lib/akop.js or lib/akop.min.js into your projects javascript directory and include it however you
include other javascript files.

For specifics about usage of individual modules please see the demo implementations in the demo directory. If you have questions
please feel free to create an issue here. I'll do my best to answer in a timely maner.

# To Contribute

Contributions are welcome, and greatly appreciated. AKOP modules are written in CoffeScript and uses Cake to build the
javascript and jasmine spec suite. The following steps assume you have CoffeeScript installed.

## Run the tests

To build and run the specs simply run this command from the root directory of the project.

```cake spec```

It will compile all of the source code and specs and open SpecRunner.html in a browser. If you have run the specs before
you may need to reload the page to make sure you're not getting cached files.

## Adding new files

Currently the Cakefile is explicitly defining all of the included files. You will need to add any new source and spec files
to the ```appFiles``` and ```specFiles``` arrays, respectively. (I'm planning to make the build process smarter in the future.)

# Modules

## Directives

### MultiSelect

MultiSelect provides the familiar file-system style hotkey selection strategy. See [demo/multi-select](demo/multi-select.html) for a
basic implementation.

## Filters

### QueryFilter

The Query filter provides an enhanced interface for filtering collections. See [demo/query-filter](demo/query-filter.html).
