# Theia IDE on Heroku

A [Heroku](https://www.heroku.com/) install of [Theia IDE](https://theia-ide.org/).

Do an automated deploy to Heroku:
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Install [Docker](https://docs.docker.com) and the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)

## Build and Run Locally

```bash
docker build -t theia/v1 .
```

```bash
docker run -p 3000:3000 -e PORT=3000 -it theia/v1 yarn theia start /home/project --hostname 0.0.0.0
```

Browse to [http://localhost:3000/](http://localhost:3000/)

## Build and Deploy

Create a Heroku app:
```bash
heroku create
```

Note the Heroku app name, and add the Heroku Git repository as a remote to this Git repository:
```bash
heroku git:remote -a [heroku-app-name]
```

Set the app's stack to container:
```bash
heroku stack:set container -a [heroku-app-name]
```

Deploy the app:
```bash
git push heroku master
```

Now open the app in your browser:
```bash
heroku open
```
