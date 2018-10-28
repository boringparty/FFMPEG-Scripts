#!/bin/bash
for dirname in BOOKS/*; do cat "${dirname}"/* > "${dirname}".mp3;done
