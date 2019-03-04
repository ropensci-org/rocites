rocites
==========

Heroku robot to tweet new citations using rOpenSci software

## what it does

* check if there are any new citations from <https://github.com/ropenscilabs/ropensci_citations/blob/master/citations.tsv> - and sends a tweet for each new citation

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

Set up env vars

```
heroku config:set ROCITES_TWITTER_CONSUMER_KEY=key
heroku config:set ROCITES_TWITTER_CONSUMER_SECRET=key
heroku config:set ROCITES_TWITTER_ACCESS_TOKEN=key
heroku config:set ROCITES_TWITTER_ACCESS_SECRET=key
heroku config:set AWS_S3_WRITE_ACCESS_KEY=key
heroku config:set AWS_S3_WRITE_SECRET_KEY=key
```

Add the scheduler to your heroku app

```
heroku addons:create scheduler:standard
heroku addons:open scheduler
```

Add the task ```rake run``` to your heroku scheduler and set to whatever schedule you want.


## Usage

- `rake run` to check for new citations and send tweets for each
- `rake new` to just check for new citations and print to the console, no tweets sent

