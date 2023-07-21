# Online freelancing app with Ruby on Rails 6

## Running this app

To run this app on your local machine, follow the subsequent steps:

### 1. Install the correct versions of Ruby, Rails, and other dependencies

This app was created with:

* **ruby 3.2.2**

* **rails 6.1.7.3**

* **postgresql 15.3-1**

* **node v16.20.0**

* **yarn 1.22.19**

* **elasticsearch 7.17.7**

Make sure you have the correct versions of the above-mentioned software installed on your local system.

### 2. Clone the repository and navigate to it

```sh
git clone git@github.com:Chitram-Dasgupta/kreeti-freelancing-app.git

cd kreeti-freelancing-app
```

### 3. Install the necessary dependencies

```sh
bundle && yarn
```

### 4. Create, migrate, and seed the databases

```sh
rails db:setup
```

### 5. Create the elasticsearch indices

Make sure that elasticsearch is running at `localhost:9200`

Open the rails console:

```sh
rails c
```

Then, inside rails console, run the following commands:

```sh
User.import force: true
```

```sh
Project.import force: true
```

### 6. Finally, run the server

```sh
rails s
```
