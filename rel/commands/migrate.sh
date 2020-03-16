#!/bin/sh

release_ctl eval --mfa "NaiveDice.ReleaseTasks.migrate/1" --argv -- "$@"
