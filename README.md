# Online freelancing app with Ruby on Rails 6

## Running this app

You need to follow the subsequent steps to run this app on your local machine:

### 1. Have the correct versions of ruby, rails, and other dependencies installed

This app was created with:

* **ruby 3.2.2**

* **rails 6.1.7.3**

* **postgresql 15.3-1**

* **node v16.20.0**

* **yarn 1.22.19**

* **elasticsearch 7.17.7**

So, it is absolutely necessary that you have the correct version of the above
mentioned software installed on your local system.

### 2. Set up the database

In the `config/database.yml`, you will find that the `username` is
**freelancing_app**, and the `password` is **password**.

So, in our postgresql installation, you need to have a *user* called
**freelancing_app** with the *password* set as **password**.

To do this, you can do the following:

```sh
sudo -su postgres
# Then enter the password

psql
# This will take us to the psql prompt

# In psql, run:
CREATE USER freelancing_app WITH PASSWORD 'password' CREATEDB;

# Then quit out of psql and postgres
```

### 3. Clone the repository and cd into it

```sh
git clone git@github.com:Chitram-Dasgupta/kreeti-freelancing-app.git

cd kreeti-freelancing-app
```

### 4. Create and migrate the databases

```sh
rails db:create

rails db:migrate

rails db:seed
```

### 5. Install the requisite dependencies

```sh
bundle

yarn
```

### 6. Create the elasticsearch indices

Please make sure that elasticsearch is running at `localhost:9200`

Open up rails console:

```sh
rails console
```

Then inside rails console, run the following:

```sh
User.import force: true

Project.import force: true
```

### 7. Finally, run the server

```sh
rails s
```
