#!groovy

library "github.com/melt-umn/jenkins-lib"

melt.setProperties(silverBase: true)

node {
try {

  def newenv = silver.getSilverEnv()

  stage ("Checkout") {
    checkout scm
    melt.clearGenerated()
  }

  stage ("Build") {
    // For this project, re-using 'generated' gains as much as parallelism, so don't bother
    withEnv(newenv) {
      sh "./build-all-artifacts"
    }
  }

  /* If we've gotten all this way with a successful build, don't take up disk space */
  melt.clearGenerated()
}
catch (e) {
  melt.handle(e)
}
finally {
  melt.notify(job: 'Oberon0')
}
} // node

