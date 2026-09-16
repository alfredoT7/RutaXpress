#!/bin/sh
#
# Gradle start up script for UN*X
#

# Attempt to set APP_HOME
PRG="$0"
while [ -h "$PRG" ] ; do
    ls=$(ls -ld "$PRG")
    link=$(expr "$ls" : '.*-> \(.*\)$')
    if expr "$link" : '/.*' > /dev/null; then
        PRG="$link"
    else
        PRG=$(dirname "$PRG")/"$link"
    fi
done
APP_HOME=$(dirname "$PRG")
APP_HOME=$(cd "$APP_HOME" && pwd)

APP_NAME="Gradle"
APP_BASE_NAME=$(basename "$0")
DEFAULT_JVM_OPTS='"-Xmx64m" "-Xms64m"'

# Determine JAVA_HOME
if [ -z "$JAVA_HOME" ] ; then
    # Try Android Studio's bundled JDK
    if [ -d "/Applications/Android Studio.app/Contents/jbr/Contents/Home" ] ; then
        JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
    elif [ -d "/Applications/Android Studio.app/Contents/jre/Contents/Home" ] ; then
        JAVA_HOME="/Applications/Android Studio.app/Contents/jre/Contents/Home"
    fi
fi

if [ -n "$JAVA_HOME" ] ; then
    JAVACMD="$JAVA_HOME/bin/java"
    if [ ! -x "$JAVACMD" ] ; then
        echo "ERROR: JAVA_HOME ($JAVA_HOME) points to invalid JDK." >&2
        exit 1
    fi
else
    JAVACMD="java"
    if ! command -v java > /dev/null 2>&1 ; then
        echo "ERROR: JAVA_HOME not set and 'java' not found in PATH." >&2
        echo "Install a JDK or open project in Android Studio first." >&2
        exit 1
    fi
fi

CLASSPATH="$APP_HOME/gradle/wrapper/gradle-wrapper.jar"

if [ ! -f "$CLASSPATH" ] ; then
    echo "ERROR: gradle-wrapper.jar not found." >&2
    echo "Open the project in Android Studio once to generate it." >&2
    exit 1
fi

eval "set -- $DEFAULT_JVM_OPTS $JAVA_OPTS $GRADLE_OPTS \
    \"-Dorg.gradle.appname=$APP_BASE_NAME\" \
    -classpath \"$CLASSPATH\" \
    org.gradle.wrapper.GradleWrapperMain \
    \"\$@\""

exec "$JAVACMD" "$@"
