#!/usr/bin/env xonsh
import sys
from os.path import dirname,abspath,join
from mako.template import Template

_DIR=dirname(abspath(__file__))
sys.path.insert(0, _DIR)
cd @(_DIR)

from config import CONFIG

template = Template($(cat template.yml))

outpath = _DIR+"/docker-compose.yml"
print(outpath)
with open(outpath,"w") as out:
  out.write(
    template.render(
      CONFIG=CONFIG
    )
  )

