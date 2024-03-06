# Git Clone Autocomplete Plugin

This Zsh/Oh My Zsh plugin enhances the `git clone` command by autocompleting GitHub repository URLs using SSH. It supports public repositories and can be configured with a GitHub token to avoid API rate limits.

## Installation

1. **Clone the Plugin**: Clone this repository into your Oh My Zsh custom plugins directory:

    ```sh
    git clone https://github.com/dcorral/gitclone-autocomplete ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/gitclone-autocomplete
    ```

2. **Update `.zshrc`**: Add `gitclone-autocomplete` to the plugins list in your `.zshrc`:

    ```sh
    plugins=(... gitclone-autocomplete)
    ```

3. **Reload Zsh**: Apply the changes by either restarting your terminal or sourcing your `.zshrc`:

    ```sh
    source ~/.zshrc
    ```

## Configuration

### GitHub Personal Access Token

To prevent hitting GitHub API rate limits, configure a personal access token:

1. **Generate Token**: Visit [GitHub's Tokens page](https://github.com/settings/tokens) and generate a new token with minimal scopes.
2. **Setup Environment Variables**:
    - Copy the `.zshprivate.template` from this repository to your home directory and rename it to `.zshprivate`.
    - Replace placeholder values in `.zshprivate` with your GitHub token and username.

    ```sh
    cp path_to_cloned_repository/.zshprivate.template ~/.zshprivate
    nano ~/.zshprivate  # Edit and save your changes
    ```

3. **Source `.zshprivate`**: Ensure `.zshprivate` is sourced in your `.zshrc`. Add the following line if it's not already there:

    ```sh
    [[ -f ~/.zshprivate ]] && source ~/.zshprivate
    ```

### `.zshprivate.template` Content

```sh
# GitHub Personal Access Token
export GITHUB_TOKEN="your_github_personal_access_token_here"

# Default GitHub username
export GITCLONE_AUTOCOMPLETE_USER="your_github_username_here"
```

## Usage

With the plugin and configuration in place, begin typing `git clone` followed by the start of a GitHub username. Autocompletion suggestions for repository URLs will appear as you type. Press `Tab` to cycle through the suggestions.
