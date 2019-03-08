
# xQuery Library Scaffold Project

An init generator producing 

 1. boilerplate source code files
 2. build, test, release and deploy scaffolding.

... into your own github 'xQuery library project'

It is expected that you will use this project,
to produce your own well tested 'modular like' xQuery libraries,
that can be used by other libraries or incorporated in an xQuery app.

## Project Scope.

In eXistdb, the library type is declared in [repo.xml](https://exist-db.org/exist/apps/doc/repo)

```
<meta xmlns="http://exist-db.org/xquery/repo">
  <type>library</type>
</meta>
```
A 'xQuery Library project' is different from an xQuery application, 
which are usually public facing web applications. 
Such application are out of scope for this project

Our 'xQuery Library project' scope is limited to 2 source code files

- the main xQuery module.
- unit-test module to test the main xQuery module functions








## What Does It Generate 

This project populates your own library project with ...
 1. starter boilerplate xQuery lib files ( content/*xqm, unit-tests/t-*.xqm )
 2. easy to tinker with XAR essentials ( inc/repo.mk, inc/expath-pkg.mk )
 3. a simple *build and test* scaffolding 
 4. travis-ci => github release-asset strategy based on tagged commits
 6. and if required a production deployment strategy, based on github webhook notification.

# Set up Steps

```
git clone git@github.com:grantmacken/xQlibScaffold.git
cd xQlibScaffold
# init with a path project-name 
./init ../newXqueryLibName
```
create a newXqueryLibName folder and populates folder with starter files
and the build and test scaffolding

```
├── xQlibScaffold :  this cloned repo
│   └── init  -> in dir run `./init ../newXqueryLibName`
├── newXqueryLibName
│   └── <- files and dir populated from ./init
```

## Bring Project Under Git Control

To make this new project, a git controlled project that can push commits 
to a github repo ...

 - [create a new repo on github](https://help.github.com/en/articles/creating-a-new-repository) 
using the 'newXqueryLibName' 
 - get the ssh `clone URL` for the newly minted repo e.g. `git@github.com:{repoOwner}/newXqueryLibName.git`
 - [add the new project to github](https://help.github.com/en/articles/adding-an-existing-project-to-github-using-the-command-line) follow instructions below.

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

# Code, Build, Test and Repeat

Use a text editor in split window mode, 
with the left window, your xQuery module and the
the right window your unit-test module
The bottom full screen widow will be your editors terminal


TODO: screenshot


## Bring Up Fresh eXist Instance Running In A Docker Container

You only have to do this once for an editing session.

```
make up
```

[![asciicast](https://asciinema.org/a/232367.svg)](https://asciinema.org/a/232367)

As seen in the cast `make up` will can load any dependencies your lib requires.

The startup script looks for a pkgs.xar file and will try to install the xars

- the package name
- the package version
- the xar download URL

```
[
  [
    "http://github.com/Schematron/schematron-exist",
    "1.1",
    "https://github.com/Schematron/schematron-exist/raw/master/dist/schematron-exist-1.1.xar"
  ]
]
```

## Code => Build => Every Time A Coconut

After a coding and saving file to disk you can run `make`.

[![asciicast](https://asciinema.org/a/232374.svg)](https://asciinema.org/a/232374)

A new deployed *version* happens every time we invoke `make`

 - [x] the module is copied into running eXist container
 - [x] an eXist compile module check is performed
 - [x] the module version is bumped, and the XAR archive created
 - [x] the XAR is installed an deployed into container

## Code => Build => Test => Unit Tests

```
make test
```

[![asciicast](https://asciinema.org/a/232381.svg)](https://asciinema.org/a/232381)

Unit test are written using [xQsuite](http://exist-db.org/exist/apps/doc/xqsuite.xml)
 annotation-based Test Framework

The xQsuite XML output is transformed into an easy to read TAP formated 'ok, not ok' report.


## Code => Build => Test => Smoke

```
make smoke
```











