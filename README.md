# xQlibScaffold

xQuery library creation scaffold for build testing and deploying expath library xars


## This scaffolding is for building xQuery *library* archive xar packages 

It is **not** capable of building apps.

In eXistdb, the type of package is defined in [repo.xml](https://exist-db.org/exist/apps/doc/repo)

```
<meta xmlns="http://exist-db.org/xquery/repo">
  <type>library</type>
</meta>
```

# Set up Steps

1. cd into your project dir 

```
git clone git@github.com:grantmacken/xQlibScaffold.git
cd xQlibScaffold
./init ../newRepoName
```
newXqueryLibName will now be populated with starter files
and the build and test scaffolding

```
├── xQlibScaffold :  this cloned repo
│   └── init  -> in dir run `./init ../newXqueryLibName`
├── newXqueryLibName
│   └── <- files and dir populated from ./init
```

To make this a git controlled project, with a github repo ...

 - [create a new repo on github](https://help.github.com/en/articles/creating-a-new-repository) 
using the 'newXqueryLibName' 
 - get the ssh `clone URL` for the newly minted repo e.g. git@github.com:{repoOwner}/newXqueryLibName.git

 - then [add new project to github](https://help.github.com/en/articles/adding-an-existing-project-to-github-using-the-command-line)

```
cd ../newXqueryLibName
git init
git add .
git commit -m "first commit"
# add the ssh clone URL from github
git remote add origin git@github.com:{repoOwner}/newXqueryLibName.git
git remote -v
git push origin master
```

--------------------------------------------------






## Repo Build Scaffolding

Compile checks and 


## Build Phase Checks

1. content/*.xqm [compiled OK!]
2. deploy/*xar   [installed and deployed OK!]

```
content/*.xqm [eXist can compile OK!] => 
 -> into build/*.xqm => 
 -> into deploy/*xar archive =>
 -> into eXistdb [eXist can install and deploy OK!]
```

Outline of source files that go into archive

```
├── .env
├── Makefile run `make` => compile test => build => xar archive
├── content
│   └── newBase60.xqm   -> build/content/*.xqm -> into archive xar
├── inc
│   ├── expath-pkg.mk:  -> build/xpath-pkg.xml         -> into archive xar
│   └── repo.mk         -> build/xpath-pkg.xml         -> into archive xar
```

Compile check depends up an running eXist instance.
The instance is started prior to the build. 
This start process only has to happen once.

```
├── .env
├── docker-compose.yml
├── Makefile => run `make up` => calls bin/exStartUp 
├── bin
│   ├── exStartUp -> starts exist container. 
```

NOTE: 
If you haven't got the docker image it will be downloaded first into your docker env.

### Attaching to existing docker network

```
├── .env <- user sets values for 
│           - PORT 
│           - USE_DC_OVERRIDE
│           - DC_OVERRIDE_NETWORK
├── docker-compose.yml
```

If you are already have eXist running in a container 

If you have another running eXist instance using the PORT in the .env file

Note: WIP TODO! ports and network

## TEST Phases

 - prior compile phase: [ content/*.xqm, unit-tests/t-*.xqm ]
 - unit-tests  - each unit-test got expected output
 - smoke tests - run example and check output
 - coverage   -  check if each function in lib under test is called


### Unit Tests

```
├── Makefile => run `make test` calls `prove -v bin/xQtest`
├── bin
│   ├── xQtest -> produces TAP report
├── content
│   └── *.xqm   [file under test] 
└── unit-tests
    └── t-*.xqm -> unit tests for content/*xqm
```

### very simple smoke test

See if output from running example matches prescribed grep pattern

```
├── Makefile => run `make smoke` calls `bin/xQcall`
├── bin
│   ├── xQcall -> runs example
```

### very very simple coverage

See if every function was called in lib by running example then inspecting trace

```
├── Makefile => run `make coverage `bin/xQcall`
├── bin
│   ├── xQcall -> enable tracing 
               -> run example 
               -> stop tracing 
               -> inpect trace
```




## Makefile Targets

 1. `make` 
    - bring the eXist docker container up. 
    - compile check: see if ./content/newBase60.xqm can be compiled
    - build the archive xar ./build/*.xar
    - deploy library (as a xar archive) into running exist container
    - [![asciicast](https://asciinema.org/a/227756.svg)](https://asciinema.org/a/227756)
 2. `make test`  
    - upload unit-test library 
    - test and produce a 'ok, not ok' TAP report 
    - [![asciicast](https://asciinema.org/a/227757.svg)](https://asciinema.org/a/227757)
 3. `make release` 
    - set *version* to a bumped latest `git tag`
    - rebuild so *version* is based on this next version
    - create tagged commit 
    - push to origin

## [Built on Travis](https://travis-ci.org/grantmacken/newBase60)

 The build on Travis also uses the same Makefile to 
  - create and deploy into running eXist instance 
  - test the library 
 
 In addition, if the Travis sees a push tagged commit 
 it will create a downloadable release asset ( the xar file ),
 which will be available as github release.

 In the deploy section in the travis file, you can see 
 the deploy trigger only occurs on master branch
 when a tagged commit to master occurs.

In the deploy section in the travis file, you can also see 
the secret key is secret api-key. 

## [Latest Release](https://github.com/grantmacken/newBase60/releases/latest)

If all goes well, the build succeeds and the tests pass then a
release asset in the form of *xar* file will be available on github.

When this downloadable *xar* file become available a 
*webhook* is is triggered. Github will post a request,
containing the release details in the sent json body,
to my designated endpoint URL.

My server receives the request. After authenticating 
the request, the sever install and deploy the library to my production eXist server.


## Opinionated Unix Way Of Looking at xQuery libraries

 - a library should try to do one thing, and do it well.
 - prefer functions that behave like a pipe 
 - string, array, map and node data is stuff in the pipe that flows between functions
 - functions may also treated as data so ... 
 - when building functions have chaining and banging in mind
     - the [chaining operator](https://www.w3.org/TR/2017/REC-xquery-31-20170321/#id-arrow-operator) => is your best friend 
     - the [bang operator](https://www.w3.org/TR/2017/REC-xquery-31-20170321/#id-map-operator) ! is a good buddy
 - use arrays, maps, nodes, over multiple args, Multiple args are not amenable to chaining and banging 
 - small modular libs are good. 
 - see each lib as something to 'plugin' in to your main app




Init xQuery files and scaffold for creating expath library xars
