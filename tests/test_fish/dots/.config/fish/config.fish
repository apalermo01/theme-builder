if status is-interactive
    # Commands to run in interactive sessions can go here
end

export PATH="$HOME/.local/share/gem/ruby/3.0.0/gems/jekyll-4.3.3/exe:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /home/alex/.ghcup/bin # ghcup-env
# Append some commands to fish init
echo "I was appended to the default config!"
fortune | cowsay -f $(ls /usr/share/cowsay/cows/ | shuf -n1)
neofetch
wal -n -e -i /home/alex/Pictures/wallpapers/cat1.jpg > /dev/null 

function show_onefetch
    if test -d .git
        onefetch
    end
end

function cd
    builtin cd $argv
    show_onefetch
end
