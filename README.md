# Oberon0

[Silver](https://github.com/melt-umn/silver) specification of Oberon0 for the [LDTA 2011 Tool Challenge](http://ldta.info/tool.html).

This tool challenge resulted in a [set of papers available here](https://dl.acm.org/citation.cfm?id=2853605) (click on table of contents).
Our paper is freely [available here](http://www-users.cs.umn.edu/~evw/pubs/kaminski15scp/index.html).

## Building and running

With a Silver installation in `PATH` you can simply run `./build-all-artifacts`.

_Note 3/2/2018: There was a test suite with example code, but this was hosted on google code and appears to have vanished._

## Repository organization

* `edu.umn.cs.melt.Oberon0/artifacts` contains a module for each artifact of the challenge
* `edu.umn.cs.melt.Oberon0/components` contains the specification of each component of the challenge (`L*` or `T*`)

The "real code" can be found here:

* `edu.umn.cs.melt.Oberon0/core` contains the "host language" implementation
* `edu.umn.cs.melt.Oberon0/core/driver` contains most of the imperative code that "runs" our compiler
* `edu.umn.cs.melt.Oberon0/constructs` contains language extensions to the "host language"
* `edu.umn.cs.melt.Oberon0/tasks` contains additional analysis/translation for the host, and each language extension

