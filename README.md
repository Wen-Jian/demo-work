# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
2.5.3

* System dependencies
OS X

* Configuration

* Database creation
rake db:create
rake db:migrate

* Database initialization
rake db:seed

* How to run the test suite
rspec spec

* Services (job queues, cache servers, search engines, etc.)
none

* Set up step under Mac OS

```
git clone https://github.com/Wen-Jian/demo-work.git

$ bundle install

$ rake db:create && rake db:seed
```

if lack the dependency of Posgresql, please run

```
$ brew update

$ brew install postgresql

$ bundle install
```

After setting up, stat server with the command below.

```
$ rails s
```

you can access the web application through browser on the localhost:3000



* ...
