#                                           _ _
#                         _   _  ___   __ _(_) |_
#                        | | | |/ _ \ / _` | | __|
#                        | |_| | (_) | (_| | | |_
#                         \__, |\___/ \__, |_|\__|
#                         |___/       |___/
# by Jeff Chiang(Tizee)
# git >= 2.29
# Have fun ;-)

# Function to get the current Git branch
function __yogit_get_current_branch {
  return git branch --show-current
}

# Function equivalent to ygpush alias in zsh
function ygpush {
  $currentBranch = __yogit_get_current_branch
    git push origin $currentBranch
}

# Function equivalent to ygpull alias in zsh
function ygpull {
  $currentBranch = __yogit_get_current_branch
    git pull origin $currentBranch
}

function ygsc($repo) {
  git clone $repo --depth=1
}

function ygc() {
  git commit
}

function ygurl {
  param(
      [string]$remote_name = "origin"
      )
    $gitUrl = git config --get "remote.$remote_name.url"
    if ($gitUrl -match '^[^@]*@([^:\/]*)([:\/])') {
      $gitUrl = $gitUrl -replace "^[^@]*@([^:\/]*)([:\/])", "https://`$1/"
    }
  $gitUrl = $gitUrl -replace '\.git$'
    echo $gitUrl
}

function ygcount() {
  git rev-list --count HEAD
}
