#!/bin/bash

# 清理缓存（可选）
rm -rf ~/.cache/common-lisp/sbcl-*/*llm-dsl* 2>/dev/null

# 运行 SBCL 并加载系统
sbcl --load load.lisp 