PostgreSQL plugin for Dokku
---------------------------

Project: https://github.com/progrium/dokku


Installation
------------
```
cd /var/lib/dokku/plugins
git clone https://github.com/Kloadut/dokku-pg-plugin postgresql
dokku plugins-install
```


Commands
--------
```
$ dokku help
     postgresql:create <app>     Create a PostgreSQL container
     postgresql:delete <app>     Delete specified PostgreSQL container
     postgresql:info <app>       Display database informations
     postgresql:link <app> <db>  Link an app to a PostgreSQL database
     postgresql:logs <app>       Display last logs from PostgreSQL contain
```

Simple usage
------------

Create a new DB:
```
$ dokku postgresql:create foo            # Server side
$ ssh dokku@server postgresql:create foo # Client side

-----> PostgreSQL container created: postgresql/foo

       Host: 172.16.0.104
       User: 'root'
       Password: 'RDSBYlUrOYMtndKb'
       Database: 'db'
       Public port: 49187
```

Deploy your app with the same name (client side):
```
$ git remote add dokku git@server:foo
$ git push dokku master
Counting objects: 155, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (70/70), done.
Writing objects: 100% (155/155), 22.44 KiB | 0 bytes/s, done.
Total 155 (delta 92), reused 131 (delta 80)
remote: -----> Building foo ...
remote:        Ruby/Rack app detected
remote: -----> Using Ruby version: ruby-2.0.0

... blah blah blah ...

remote: -----> Deploying foo ...
remote: 
remote: -----> App foo linked to postgresql/foo database
remote:        DATABASE_URL=postgres://root:RDSBYlUrOYMtndKb@172.16.0.104/db
remote: 
remote: -----> Deploy complete!
remote: -----> Cleaning up ...
remote: -----> Cleanup complete!
remote: =====> Application deployed:
remote:        http://foo.server
```


Advanced usage
--------------

Inititalize the database with SQL statements:
```
cat init.sql | dokku postgresql:create foo
```

Deleting databases:
```
dokku postgresql:delete foo
```

Linking an app to a specific database:
```
dokku postgresql:link foo bar
```

PostgreSQL logs (per database):
```
dokku postgresql:logs foo
```

Database informations:
```
dokku postgresql:info foo
```
