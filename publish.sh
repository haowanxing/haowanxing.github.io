#!/bin/sh
echo Starting..
hexo clean && hexo g && hexo d
echo End publish.
