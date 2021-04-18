# Testy jednostkowe w MySQL

## Instalacja narzędzia do testów

Do testów używamy [MyTAP](https://hepabolu.github.io/mytap/), który należy pobraćdo katalogu `mytap`.

Po uruchomieniu dockera wydajemy w terminalu polecenie:

```shell
$ docker-compose exec db /bin/bash
```

Po wejściu do terminala kontenera z bazą, przechodzimy do katalogu `mytap`

```shell
$ cd /mytap
```

następnie wydajemy polecenie

```shell
$ ./install.sh -u root -p password
```

To spowoduje zainstalowanie narzędzie MyTAP w bazie danych.

## Testowanie

W katalogu `tests` znajduje sięprzykładpowy plik z testem. Będąc nadal zalogowanym w kontenerze przechodzimy do
katalogu `mysql_tests`

```shell
$ cd /mysql_tests
```

i w tym katalogu uruchamiamy test poleceniem

```shell
$ mysql -u root --disable-pager --batch --raw --skip-column-names --unbuffered -p  --database container_db --execute 'source test.sql'
```

lub bez wchodzenia do kontenera
```shell
$ docker-compose exec db mysql -u root --disable-pager --batch --raw --skip-column-names --unbuffered -p --database container_db --execute 'source /mysql_tests/test.sql'
```

Pełna dokumentacja znajduje się na stronie [MyTAP](https://hepabolu.github.io/mytap/documentation/)