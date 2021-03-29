#!/bin/bash
# Note for security purpose, use only in a single user system.
# I use this in linux rescue mode to download git large file
# For Debian & Ubuntu

SCRIPT_PATH="$(dirname "$(readlink -f "$0")")"
SETUP_GIT_URL="https://token@github.com/sofibox/maxisetup.git"
GIT_TOKEN="YOUR-GIT-TOKEN-KEY"

if [[ "${GIT_TOKEN}" == "YOUR-GIT-TOKEN-KEY" || -z "${GIT_TOKEN}" ]]; then
  read -r -s -p "Enter GIT TOKEN: " GIT_TOKEN
  echo
fi

# Install git
if ! command -v git &>/dev/null; then
	sudo apt-get -y install git
fi
# Install git-lfs, without this git will not download the large file into git directory
# instead the file only contain the checksum and size details

if ! command -v git-lfs &>/dev/null; then
   curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
   sudo apt-get -y install git-lfs
fi

mkdir -p "${SCRIPT_PATH}/download"
cd "${SCRIPT_PATH}/download"
echo "Setting up temporary git authentication for private repository ..."
cat /dev/null >"${SCRIPT_PATH}/download/.git-askpass"
echo "#!/bin/bash" >>"${SCRIPT_PATH}/download/.git-askpass"
echo "echo ${GIT_TOKEN}" >>"${SCRIPT_PATH}/download/.git-askpass"
chmod +x "${SCRIPT_PATH}/download/.git-askpass"
export GIT_ASKPASS="${SCRIPT_PATH}/download/.git-askpass"
echo "Removing existing maxisetup repository ..."
# remove existing clone
rm -rf "${SCRIPT_PATH}/download/maxisetup"
echo "Cloning new maxisetup repository ..."
echo "=~=~=~=~=~=~=~"
git clone "${SETUP_GIT_URL}"
echo "=~=~=~=~=~=~=~"
# Now we have setup folder.
cp "${SCRIPT_PATH}/download/maxisetup/storage/os/debian/debian10-mod.iso" "${SCRIPT_PATH}/mini.iso"
# Delete these files
echo "Removing git authentication and destroying its environment variable ..."
rm -f "${HOME}/.git-askpass"
unset GIT_ASKPASS
