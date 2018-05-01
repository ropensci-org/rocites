rocites
==========

Heroku robot to tweet new citations using rOpenSci software

## what it does

* check if there are any new citations from <https://github.com/ropensci/roapi/blob/master/data/citations.csv> - and sends a tweet for each new citation

## Install

```
git clone git@github.com:ropenscilabs/rocites.git
cd rocites
```

## Setup

Create the app (use a different name, of course)

```
heroku apps:create ropensci-rocites
```

Push your app to Heroku

```
git push heroku master
```

Add the scheduler to your heroku app

```
heroku addons:create scheduler:standard
heroku addons:open scheduler
```

Add the task ```rake run``` to your heroku scheduler and set to whatever schedule you want.


## Usage

If you have your repo in an env var as above, run the rake task `run`

```
rake run
```

If not, then pass the repo to `run` like

```
rake run repo=owner/repo
```

## Rake tasks

* rake envs  # list env vars
* rake run   # checks for new packages or new releases
