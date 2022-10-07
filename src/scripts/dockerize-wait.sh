#!/bin/bash
dockerize -wait "http://127.0.0.1:3000/${PARAM_ENDPOINT}" -timeout "${PARAM_TIMEOUT}m"