# :toolbox: Django Toolbox

Tooling and test execution support for [Django][0] :unicorn:


## Highlights

- :test_tube: Test supported core database backends — MariaDB, MySQL, Oracle, PostgreSQL, SQLite
- :earth_africa: Test supported core geospatial backends — MariaDB, MySQL, Oracle, PostGIS, SpatiaLite
- :globe_with_meridians: Test user interfaces in different browsers using Selenium — Chrome, Edge, Firefox
- :snake: Test using different Python interpreters — CPython, PyPy
- :broom: Execute linting and formatting tools on the Django repository
- :books: Build the project documentation using Sphinx and run spelling and link checkers


## Quickstart

1. Make sure that you have Docker installed.

2. Clone this repository as well as the Django repository, e.g.

   ```console
   $ mkdir ~/Sources
   $ cd ~/Sources
   $ git clone https://github.com/django/django.git
   $ git clone https://github.com/django-docker-box/django-docker-box.git
   $ cd django-docker-box
   ```

> [!IMPORTANT]
> As long as the two repositories are adjacent the Django source repository will be discovered.
> A different path can be specified by setting the `DJANGO_PATH` environment variable.

3. Build the image:

   ```console
   $ docker compose build sqlite
   ```

4. Run the tests:

   ```console
   $ docker compose run --rm sqlite
   ```

> [!TIP]
> All arguments are passed to `tests/runtests.py`.
> Before they are run all specific dependencies are installed (and cached across runs).


## Running Tests


### Standard Tests

To run the standard set of tests you can use the following commands:

```console
$ docker compose run --rm mariadb [args]
$ docker compose run --rm mysql [args]
$ docker compose run --rm oracle [args]
$ docker compose run --rm postgres [args]
$ docker compose run --rm sqlite [args]
```

Each of the above commands will run the test suite for a different supported database.


### Geospatial Tests

To run tests on geospatial features you can use the following commands:

```console
$ docker compose run --rm mariadb-gis [args]
$ docker compose run --rm mysql-gis [args]
$ docker compose run --rm oracle-gis [args]
$ docker compose run --rm postgres-gis [args]
$ docker compose run --rm sqlite-gis [args]
```

Each of the above commands will run the test suite for a different supported geospatial database.


### User Interface Tests

To run tests on user interfaces you can use the following commands:

```console
$ docker compose run --rm chrome [args]
$ docker compose run --rm edge [args]
$ docker compose run --rm firefox [args]
```

Each of the above commands will run the test suite for a different supported web browser.

The tests are executed using Selenium.


## Running Tools


### Linting & Formatting

Django uses the following linting and formatting tools: `black`, `flake8`, `isort`, and `eslint`.
To ensure that the correct versions are used, Django also supports using `pre-commit`:

```console
$ docker compose run --rm pre-commit
```


### Building Documentation

Documentation for Django is built using Sphinx. Run the following to see the available commands:

```console
$ docker compose run --rm sphinx
```

You may find the following particularly useful when working on documentation improvements:

```console
$ docker compose run --rm sphinx html
$ docker compose run --rm sphinx spelling
$ docker compose run --rm sphinx linkcheck
```

The `BUILDDIR` environment variable has been set to generate output into the `./output/docs` path
under this repository instead of the usual location in the Django source repository. You can alter
this environment variable to generate to a different path if required.


### Other

To enter a shell within the container, run:

```console
$ docker compose run --rm --entrypoint=bash sqlite
```

## Configuration

The build of the container image can be customized by setting the following environment variables:

| Environment Variable    | Default Value | Description                                          |
| ----------------------- | ------------- | ---------------------------------------------------- |
| `DJANGO_PATH`           | `../django`   | Path to the Django repostory on your local machine   |
| `PYTHON_IMPLEMENTATION` | `python`      | Implementation of Python to use — `python` or `pypy` |
| `PYTHON_VERSION`        | `3.10`        | Version of Python container image to use             |

The versions of various backend services can be switched by setting these environment variables:

| Environment Variable    | Default Value | Description                                          |
| ----------------------- | ------------- | ---------------------------------------------------- |
| `MARIADB_VERSION`       | `10.5`        | Version of MariaDB container image to use            |
| `MYSQL_VERSION`         | `8.0`         | Version of MySQL container image to use              |
| `ORACLE_VERSION`        | `23.5.0.0`    | Version of Oracle container image to use             |
| `POSTGRESQL_VERSION`    | `13`          | Version of PostgreSQL container image to use         |
| `POSTGIS_VERSION`       | `3.0`         | Version of PostGIS extension to use                  |


### Python Versions

The `PYTHON_VERSION` environment variable customizes which version of Python you are running the tests against. e.g:

```console
$ PYTHON_VERSION=3.10 docker compose run --rm sqlite
```


### Database Versions

Most database container images are pulled from [Docker Hub][1]. Oracle database
is pulled from the [Oracle Container Registry][2].

You can switch the version of the database you test against by changing the
appropriate environment variable. Available options and their defaults can be
found in the [configuration section](#Configuration).

Be aware that only a single version of a particular database may be running at
one time, so you will need to ensure that you tear down the previously running
instance before starting up the new one, e.g.

```console
$ docker compose ps --format='{{.Image}}' postgresql-db
postgres:13-alpine
$ docker compose down postgresql-db
[+] Running 1/1
 ✔ Container django-docker-box-postgresql-db-1  Removed                    0.2s
$ POSTGRESQL_VERSION=17 docker compose up --detach postgresql-db
[+] Running 1/1
 ✔ Container django-docker-box-postgresql-db-1  Started                    0.3s
$ docker compose ps --format='{{.Image}}' postgresql-db
postgres:17-alpine
```

Unlike other GIS database backends, for PostgreSQL with PostGIS you will need
to specify both versions:

```console
$ POSTGRESQL_VERSION=17 POSTGIS_VERSION=3.5 docker compose up --detach postgresql-gis-db
```

To determine what database versions can be used you can check the release notes
for the branch of Django that you have checked out or alternatively there is the
[supported database versions][3] page on Django's Trac Wiki.


### Other Versions

For the Memcached, Redis, and Selenium container images, the latest container
image tag is always used.

Where possible, for backend services, we also use Alpine images where available
for smaller image size and sometimes improved performance.


## Roadmap

The following list is a collection of ideas for improvements that could be made
with no promises that they'll be delivered:

- Add a monthly scheduled full test matrix execution using GitHub Actions
- Add support for some third-party databases, e.g. CockroachDB, SQL Server
- Add support for test coverage execution and report generation
- Add support for running accessibility tooling and report generation
- Support report generation during monthly runs and publish to GitHub Pages
- Publish pre-built container images to the GitHub Container Registry
- Support testing against different versions of SQLite and SpatiaLite
- Support running with Podman in addition to Docker


[0]: https://www.djangoproject.com/
[1]: https://hub.docker.com/search?badges=official&badges=open_source
[2]: https://container-registry.oracle.com/ords/ocr/ba/database/free
[3]: https://code.djangoproject.com/wiki/SupportedDatabaseVersions
