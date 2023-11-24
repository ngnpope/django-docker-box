# django-docker-box

Run the django test suite across multiple databases.

## Quickstart

Clone this repository somewhere. Also make sure you have docker installed.

Ensure that the `DJANGO_PATH` variable points to the root of the Django repo:

```console
$ export DJANGO_PATH=~/projects/django/`
```

If you see a docker compose warning about it not being defined followed by an error ensure that is defined in the shell you are using.

You can now either download the latest image used on the CI servers with the dependencies pre-installed:

```console
$ docker compose pull sqlite
```

Or build it yourself:

```console
$ docker compose build sqlite
```

Then simply run:

```console
$ docker compose run --rm sqlite
```

All arguments are passed to `runtests.py`. Before they are run all specific dependencies are
installed (and cached across runs).

## Different databases

Simply substitute `sqlite` for any supported database:

```console
$ docker compose run --rm postgresql [args]
$ docker compose run --rm mysql [args]
$ docker compose run --rm mariadb [args]
```

#### Database versions

You can customize the version of the database you test against by changing the appropriate `[db]_VERSION` environment variable. See the Configuration section below for the available options and their defaults.

## Different Python versions

The `PYTHON_VERSION` environment variable customizes which version of Python you are running the tests against. e.g:

```console
$ PYTHON_VERSION=3.8 docker compose run --rm sqlite
```

You can also pull the pre-built image in the same way:

```console
PYTHON_VERSION=3.8 docker compose pull sqlite
```

## Utilities

To run the docs spellchecker:

```console
$ docker compose run --rm docs
```

Or pre-commit:

```console
docker compose run --rm pre-commit
```

To enter a bash shell within the container, run:

```console
docker compose run --rm --entrypoint bash [database]
```

## Configuration

| Environment Variable | Default | Description |
| --- | --- | --- |
| `DJANGO_PATH` | `../django` | The path to the Django codebase on your local machine |
| `PYTHON_IMPLEMENTATION` | `python` | One of `python` or `pypy` |
| `PYTHON_VERSION` | `3.12` | The python version to run tests against |
| `MARIADB_VERSION` | `11.2` | The MariaDB version to use |
| `MYSQL_VERSION` | `8` | The MySQL version to use |
| `ORACLE_VERSION` | `23.3.0.0` | The Oracle version to use |
| `POSTGIS_VERSION` | `3.4` | The PostGIS version to use
| `POSTGRESQL_VERSION` | `16` | The PostgreSQL version to use |
