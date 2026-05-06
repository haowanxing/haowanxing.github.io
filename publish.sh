#!/bin/sh
echo Starting..
npx hexo clean && npx hexo g && npx hexo d
echo End publish.
