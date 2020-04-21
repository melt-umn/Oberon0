# Oberon0

[Silver](https://github.com/melt-umn/silver) specification of Oberon0 for the [LDTA 2011 Tool Challenge](http://ldta.info/tool.html).

This tool challenge resulted in a [set of papers available here](https://dl.acm.org/citation.cfm?id=2853605) (click on table of contents).
Our paper is freely [available here](http://www-users.cs.umn.edu/~evw/pubs/kaminski15scp/index.html).

## Authors
- Ted Kaminski, University of Minnesota, tedinski@umn.edu
- Eric Van Wyk, University of Minnesota, evw@umn.edu,
  ORCID: https://orcid.org/0000-0002-5611-8687
- Lucas Kramer, University of Minnesota, krame505@umn.edu,
  ORCID: https://orcid.org/0000-0001-6719-6894

## Releases
- Release 0.1.0: made in April, 2020
- Release 0.1.1: made in April, 2020

## License
This software is distributed under the GNU Lesser General Public License. See the file LICENSE for details.  
More information can be found at http://www.gnu.org/licenses/.

## Related publications

Release 0.1.0 is the version discussed in the paper
"A modular specification of Oberon0 using the Silver attribute grammar system"
by Ted Kaminski and Eric Van Wyk, published in the Science of Computer Programming
special issue, LDTA (Language Descriptions, Tools, and Applications) Tool Challenge.
See DOI https://doi.org/10.1016/j.scico.2015.10.009.

Release 0.1.1 is discussed in the paper "Reflection of Terms in
Attribute Grammars: Design and Applications" by Lucas Kramer, Ted
Kaminski, and Eric Van Wyk.  At the time of release this paper has
been submitted to the Journal of Computer Languages (COLA).

It is an extension of ``Reflection in Attribute Grammars'' by the same
authors, presented at the 2019 ACM SIGPLAN
International Conference on Generative Programming: Concepts &
Experiences (GPCE).
See DOI https://doi.org/10.1145/3357765.3359517.


## Building and running

With a Silver installation in `PATH` you can simply run `./build-all-artifacts`.
This will compile the extended version of Silver needed to build Oberon0 and then use that to build Oberon0.

Be sure that Silver version 0.4.2 is used since it contains the new term-rewriting features used here.

_Note 3/2/2018: There was a test suite with example code, but this was hosted on google code and appears to have vanished._

## Required Software
- Silver version 0.4.2.  Availble at https://melt.cs.umn.edu/silver and archived at https://doi.org/10.13020/D6QX07.

## Repository organization
The Silver source files of the specification are all contained under the `grammars/` directory.

* `grammars/edu.umn.cs.melt.Oberon0/artifacts` contains a module for each artifact of the challenge
* `grammars/edu.umn.cs.melt.Oberon0/components` contains the specification of each component of the challenge (`L*` or `T*`)

The "real code" can be found here:

* `grammars/edu.umn.cs.melt.Oberon0/core` contains the "host language" implementation
* `grammars/edu.umn.cs.melt.Oberon0/core/driver` contains most of the imperative code that "runs" our compiler
* `grammars/edu.umn.cs.melt.Oberon0/constructs` contains language extensions to the "host language"
* `grammars/edu.umn.cs.melt.Oberon0/tasks` contains additional analysis/translation for the host, and each language extension

This language specification makes use of an extension to Silver, allowing for the use of Oberon0 concrete syntax in
constructing abstract syntax tree literals.
The specification of this "Silver-Oberon0" extension can be found here:

* `grammars/edu.umn.cs.melt.exts.silver.Oberon0/concretesyntax` contains the concrete syntax of the Silver-Oberon0 extension
* `grammars/edu.umn.cs.melt.exts.silver.Oberon0/abstractsyntax` contains the abstract syntax of the Silver-Oberon0 extension
* `grammars/edu.umn.cs.melt.exts.silver.Oberon0/composed/with_Oberon0` contains the composed specification of Silver extended with Silver-Oberon0
