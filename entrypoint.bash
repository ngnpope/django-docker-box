#!/bin/bash

if [[ -z "${COVERAGE}" ]]
then
    python -Wall runtests.py ${@}
else
    python -Wall -m coverage run runtests.py ${@}
    python -m coverage combine
    python -m coverage html
    python -m coverage json
    python -m coverage xml
fi
