#!/bin/sh

bc -l -e '16' | awk -f bin.awk | xargs -n1 -I{} awk -v subs={} -f p.awk test | awk '{s += +$0; print $0} END {print s}'
