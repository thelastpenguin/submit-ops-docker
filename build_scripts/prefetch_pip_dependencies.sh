# note that this is just fetching the big stuff and, in particular, the stuff in production 
# for the moment. eventually it would be GREAT to have this properly prefetch the local dependencies 
# ideally without having to first commit those dependencies into production
# but for the time being this is still WAY better than fetching everything EVERY time we start up :D

# NOTE: this is taken from update_submit, if changes are made there they must be reflected here
HOME=/home/submit 

# Load virtual environment
if [ ! -d $HOME/venv ]; then
    virtualenv $HOME/venv
fi
source $HOME/venv/bin/activate

# Finally doing the pip install
pip install --upgrade submit[prod]
