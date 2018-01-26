# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This script imports the latest strings, creates a commit, pushes
# it to the bot's repository and creates a pull request.

# If a command fails then do not proceed and fail this script too.
set -e
chmod +x ./tools/taskcluster/install-google-cloud.sh
./tools/taskcluster/install-google-cloud.sh
chmod +x ./tools/taskcluster/google-firebase-testlab-login.sh
./tools/taskcluster/google-firebase-testlab-login.sh

# Compile test builds
./gradlew assembleFocusWebviewDebug assembleFocusWebviewDebugAndroidTest

# Execute test set
./google-cloud-sdk/bin/gcloud --format="json" firebase test android run --app="app/build/outputs/apk/app-focus-webview-debug.apk" \
--test="app/build/outputs/apk/app-focus-webview-debug-androidTest.apk" \
--results-bucket="focus_android_test_artifacts" --timeout="50m" --no-auto-google-login \
--test-runner-class="android.support.test.runner.AndroidJUnitRunner" \
--device="model=Nexus5X,version=23" --device="model=Nexus9,version=25" \
--device="model=sailfish,version=25" --device="model=sailfish,version=26" \

# Pull the artifacts from TestCloud to taskcluster
# Google storage folder name can be modified from the Google Cloud menu
mkdir test_artifacts
./google-cloud-sdk/bin/gsutil ls gs://focus_android_test_artifacts | tail -1 | ./google-cloud-sdk/bin/gsutil -m cp -r -I ./test_artifacts