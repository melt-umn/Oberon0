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

  stage("Test") {
    def examples=['examples/negative/name_errors/L1',
                  'examples/negative/name_errors/L3',
                  'examples/negative/name_errors/L4'
                  'examples/negative/parse_errors/L1',
                  'examples/negative/parse_errors/L2',
                  'examples/negative/parse_errors/L3',
                  'examples/negative/parse_errors/L4',
                  'examples/negative/type_errors/L1',
                  'examples/negative/type_errors/L2',
                  'examples/negative/type_errors/L3',
                  'examples/negative/type_errors/L4',
                  'examples/positive/L1',
                  'examples/positive/L2',
                  'examples/positive/L3',
                  'examples/positive/L4']

    def tasks = [:]
    tasks << examples.collectEntries { t -> [(t): task_test(t, newenv)] }
    
    parallel tasks
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

// Build a specific example in the local workspace
def task_test(String examplepath, newenv){  
  return {
    // Each parallel task executes in a seperate node
    node {
      melt.clearGenerated()      
      withEnv(newenv) {
        dir("${examplepath}") {
          sh "./run test"
        }
      }
    }
  }
}