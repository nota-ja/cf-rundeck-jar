#!/bin/bash

set -x

## Calculate memory actually assigned to Java process
## '* 75 / 110' comes from:
##   - https://github.com/cloudfoundry/java-buildpack-memory-calculator/blob/6a7690ba8d6ae97b0c87209f22a2ad09d6098504/memory/allocator.go#L179-L181
##   - https://github.com/cloudfoundry/java-buildpack/blob/485c4552f9465b7e4dcf0acb0bdab43087e4637b/config/open_jdk_jre.yml#L32-L37
mem=$(echo $MEMORY_LIMIT | perl -ne '/(\d+)([gmk])/; $mx = $1; $factor = $2; if ($factor eq "g") { $mx = $mx * 1024 * 1024 } elsif ($factor eq "m") { $mx = $mx * 1024 }; print (int($mx))')
heap=$(($mem * 75 / 110))
stack=$(($mem * 5 / 110))

export JAVA_TOOL_OPTIONS="-Xmx${heap}k -Xss${stack}k -Dfile.encoding=UTF-8"

java -Dserver.http.port=$PORT -jar application.jar
