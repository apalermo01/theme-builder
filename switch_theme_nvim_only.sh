#!/bin/bash

source $(pwd)/env/bin/activate 

python main.py --theme $1 \
               --no-test \
               --migration-method copy \
               --destination-root $HOME \
               --destination-structure config \
               --nvim-only

deactivate
