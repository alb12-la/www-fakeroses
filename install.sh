# install jekyll
## Check for requirements when on the pi
if [[ $(uname) == *"Linux"* ]]; then
    printf "******************************\n"
    printf "* Checking for requirements"
    printf "\n******************************\n"
    # install cron that calls the run script 
    dpkg -s ruby &> /dev/null
    if [ $? -eq 0 ]; then
        echo "ruby already installed"
    else
        echo "Installing ruby ..."
        sudo apt-get install ruby-full build-essential zlib1g-dev

        echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
        echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
        echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
        source ~/.bashrc

        gem install jekyll bundler
    fi
fi

# build files

# rsync from local storage to www
