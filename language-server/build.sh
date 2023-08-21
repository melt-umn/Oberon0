#!/bin/bash

set -e

mvn install:install-file -Dfile=../oberon0_a5.jar -DgroupId=edu.umn.cs.melt -DartifactId=oberon0 -Dversion=0.4.4-SNAPSHOT -Dpackaging=jar -DgeneratePom=true


mvn package