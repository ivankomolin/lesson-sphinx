Requirements:
 - Docker v18.09+
 - Docker-compose v1.23+
 - Git

Clone repo
```
$ git clone https://github.com/ivankomolin/lesson-sphinx.git ./
```

1. Upload dump marvel.sql into exist database
2. Edit etc/sphinx.conf for setting exist database


Create index
```
$ make index
```
```
Sphinx 3.1.1 (commit 612d99f4)
Copyright (c) 2001-2018, Andrew Aksyonoff
Copyright (c) 2008-2016, Sphinx Technologies Inc (http://sphinxsearch.com)

using config file '/app/etc/sphinx.conf'...
indexing index 'marvel'...
collected 16376 docs, 0.4 MB
sorted 0.1 Mhits, 100.0% done
total 16376 docs, 398.4 Kb
total 0.1 sec, 5.251 Mb/sec, 215851 docs/sec
```

Start searchd
```
$ make start
```

Connect to searchd
```
$ make client
```
```
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 1
Server version: 3.1.1 (commit 612d99f4) 

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]> 
```


Simple example search heroes with facets
```
MySQL [(none)]> SELECT id, * FROM marvel WHERE MATCH('spider') FACET character FACET hair FACET eye FACET sex;
```
```
+-------+----------------------------------------------------+
| id    | name                                               |
+-------+----------------------------------------------------+
| 16172 | \"Spider-Girl\" (Mutant\/Spider Clone) (Earth-616) |
|     1 | Spider-Man (Peter Parker)                          |
|  2848 | Peter Parker (Spider-Skeleton) (Earth-616)         |
|  4216 | Spyder (Earth-616)                                 |
|  7793 | Scarlet Spider (Asian) (Earth-616)                 |
|  7867 | Saboteur (Earth-616)                               |
|  8176 | Saboteur (Fourth) (Earth-616)                      |
|  8521 | Spider (Outlaw) (Earth-616)                        |
| 10216 | Vern (Spider-Man) (Earth-616)                      |
| 10349 | Arranger (Scarlet Spider) (Earth-616)              |
| 10353 | Devil-Spider (Earth-616)                           |
| 11695 | Spider God (Earth-616)                             |
| 12224 | Acrobat (Spider-Squad) (Earth-616)                 |
| 12255 | Strongman (Spider-Squad) (Earth-616)               |
| 12258 | Tumbler (Spider-Squad) (Earth-616)                 |
| 14493 | Father Spider (Earth-616)                          |
| 14535 | Scarlet Spider (Criminal) (Earth-616)              |
| 14542 | Spider-Mech (Earth-616)                            |
| 15523 | Ralph (Spider-Woman Character) (Earth-616)         |
| 16213 | Dave (Scarlet Spider Character) (Earth-616)        |
+-------+----------------------------------------------------+
20 rows in set (0.01 sec)

+-----------+----------+
| character | count(*) |
+-----------+----------+
| Neutral   |        3 |
| Good      |        3 |
| Bad       |        8 |
|           |        6 |
+-----------+----------+
4 rows in set (0.01 sec)

+--------+----------+
| hair   | count(*) |
+--------+----------+
| Blond  |        1 |
| Brown  |        2 |
|        |       11 |
| Blue   |        1 |
| White  |        2 |
| Black  |        1 |
| Purple |        1 |
| Grey   |        1 |
+--------+----------+
8 rows in set (0.01 sec)

+-------+----------+
| eye   | count(*) |
+-------+----------+
| Brown |        1 |
| Hazel |        1 |
|       |       17 |
| Red   |        1 |
+-------+----------+
4 rows in set (0.01 sec)

+--------+----------+
| sex    | count(*) |
+--------+----------+
| Female |        3 |
| Male   |       14 |
|        |        3 |
+--------+----------+
3 rows in set (0.01 sec)

```

Example select single facet filter:
```
MySQL [(none)]> SELECT GROUPBY() as value, COUNT(*) as count FROM marvel WHERE MATCH('spider') AND eye!='' GROUP BY eye ORDER BY count DESC;
```
```
+-------+-------+
| value | count |
+-------+-------+
| Hazel |     1 |
| Red   |     1 |
| Brown |     1 |
+-------+-------+
3 rows in set (0.00 sec)
```

Example select facet filter in the form of a slider:
```
MySQL [(none)]> SELECT MIN(year), MAX(year) FROM marvel WHERE MATCH('spider') AND year>0;
```
```
+-----------+-----------+
| min(year) | max(year) |
+-----------+-----------+
|      1954 |      2013 |
+-----------+-----------+
1 row in set (0.00 sec)

```