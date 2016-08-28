#
# ~/.bash_profile
#

for file in ~/.{utils,bash_prompt,aliases,functions,path,dockerfunc,extra,exports}; do
    [[ -r "$file" ]] && [[ -f "$file" ]] && source "$file"
done
unset file

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
