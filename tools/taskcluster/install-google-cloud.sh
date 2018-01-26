# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This script imports the latest strings, creates a commit, pushes
# it to the bot's repository and creates a pull request.

# If a command fails then do not proceed and fail this script too.
set -e

# Install gcloud via silent install
curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-184.0.0-linux-x86_64.tar.gz --output gcloud.tar.gz
tar -xvf gcloud.tar.gz
./google-cloud-sdk/install.sh --quiet