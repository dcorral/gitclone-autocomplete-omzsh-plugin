# Define the cache file location
CACHE_DIR="$HOME/.cache/gitclone-autocomplete"
CACHE_FILE="$CACHE_DIR/ssh_urls.cache"

# Ensure the cache directory exists
if [ ! -d "$CACHE_DIR" ]; then
    mkdir -p "$CACHE_DIR"
fi

# Function to fetch repositories and update the cache
_update_repo_cache() {
    local user="$1"
    # Fetch the repositories using the GitHub API
    local repos_json=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/users/${user}/repos?type=public&per_page=100")
    # Extract the SSH URL for each repository and save to the cache file
    echo $repos_json | jq -r '.[].ssh_url' > "$CACHE_FILE"
}

_git_clone_repos() {
    # Ensure cache exists and is not empty; otherwise, update the cache
    if [ ! -s "$CACHE_FILE" ]; then
        local user="${GITCLONE_AUTOCOMPLETE_USER:-YOUR_DEFAULT_GITHUB_USERNAME}"
        _update_repo_cache $user
    fi

    # Read URLs from the cache file and add them to the completion list
    while IFS= read -r line; do
        compadd "$line"
    done < "$CACHE_FILE"
}

# Function for git-clone autocompletion
_git-clone() {
    _git_clone_repos
}

# Register the autocomplete function for git-clone
compdef _git-clone 'git-clone'


# Background cache update
# Update the cache file periodically in the background to ensure it stays current
# without affecting the user's interactive shell experience.
(( $+commands[zsh-async] )) && {
    # Load zsh-async library
    source ${(q-)path_to_zsh_async}/async.zsh

    # Initialize a new zsh-async worker
    async_start_worker my_worker -n

    # Define a callback function to update the cache file
    async_register_callback my_worker _update_repo_cache

    # Update the cache file every hour in the background
    ZSH_ASYNC_REFRESH_INTERVAL=3600
    while true; do
        async_job my_worker _update_repo_cache "${GITCLONE_AUTOCOMPLETE_USER:-YOUR_DEFAULT_GITHUB_USERNAME}"
        sleep $ZSH_ASYNC_REFRESH_INTERVAL
    done &
}


