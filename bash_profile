# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
# * ~/.utils is for any utility functons used by other shell dotfiles

for file in ~/.{bash_prompt,utils,aliases,functions,path,dockerfunc,extra,exports}; do
    [[ -r "$file" ]] && [[ -f "$file" ]] && source "$file"
done
unset file

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
