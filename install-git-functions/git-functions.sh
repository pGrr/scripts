

#################
# GIT FUNCTIONS #
#################

# caap <MESSAGE> = commit all and push
function caap {
    git add -A && git commit -m "$*" && git push
}

