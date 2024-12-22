#!/bin/bash
rm -rf ~/.cache/common-lisp/sbcl-*/llm-dsl-* 2>/dev/null
sbcl --load main.lisp "$@" 