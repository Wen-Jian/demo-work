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


For creating/editing product please login as admin 

name: admin
account: admin
password: Admin123

There are 4 type user_role
1. admin: The heightest user role who can change user_role, create/edit product.

2. authorized_role: The user who is authorized to create/edit product and edit his/her user information.

3. prime user: The user can access the discount price for products and edit his/her user information

4. normal user: basic membership who can only edit the his/her user informaion.

