# Online freelancing app with Ruby on Rails 6

## Running this app

You need to follow the subsequent steps to run this app on your local machine:

### 1. Have the correct versions of ruby, rails, node, and yarn

This app was created with:

* **ruby 3.2.2**

* **rails 6.1.7.3**

* **node v16.20.0**

* **yarn 1.22.19**

* **elasticsearch 7.17.7**

So, it is absolutely necessary that you have the correct versions of *ruby* and
*rails* installed on your system.

## 2. Install Postgresql

This app uses **postgresql 15.3-1** as the database. So, follow the installation
instructions for the distribution of your choice.

## 3. Set up the database

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

### 4. Clone the repository and cd into it

```sh
git clone git@github.com:Chitram-Dasgupta/kreeti-freelancing-app.git

cd kreeti-freelancing-app
```

### 5. Create and migrate the databases

```sh
rails db:create

rails db:migrate

rails db:seed
```

### 6. Install the requisite dependencies

```sh
bundle
```

### 7. Set up webpacker

```sh
rails webpacker:install

# This is important to remove or else the webpacker will not compile
rm babel.config.js

rails webpacker:compile
```

### 8. Create the elasticsearch indices

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

### 9. Finally, run the server

```sh
rails s
```

Open the browser and navigate to `localhost:3000`
