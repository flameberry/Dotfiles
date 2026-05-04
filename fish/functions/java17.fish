function java17
    set -g -x JAVA_HOME (/usr/libexec/java_home -v 17)
    set -gx PATH $JAVA_HOME/bin $PATH
    java -version
end
