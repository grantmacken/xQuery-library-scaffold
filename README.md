
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
which are usually public facing web application. 
Such application are out of scope for this project

Our 'xQuery Library project' scope is limited to 2 source code files

- the main xQuery module.
- unit-test module to test the main xQuery module functions

## What does it generate 

This project populates your github xQuery library project with the source code files
 1. starter boilerplate xQuery lib files ( content/*xqm, unit-tests/t-*.xqm )
 2. easy to tinker with XAR essentials ( inc/repo.mk, inc/expath-pkg.mk )

This project provides for your project a simple *build and test* scaffolding.

 - for local building ( `make` ) and unit testing ( `make test` )
 - for travis-ci,  when you commit and push

# Set up Steps

```
git clone git@github.com:grantmacken/xQlibScaffold.git
cd xQlibScaffold
./init ../newXqueryLibName
```
newXqueryLibName will now be populated with starter files
and the build and test scaffolding

```
├── xQlibScaffold :  this cloned repo
│   └── init  -> in dir run `./init ../newXqueryLibName`
├── newXqueryLibName
│   └── <- files and dir populated from ./init
```

We new to make this new project, a git controlled project that can push commits 
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




