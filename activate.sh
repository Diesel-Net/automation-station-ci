# https://github.com/game-ci/unity-builder/blob/main/dist/steps/activate.sh

# Activate license
ACTIVATION_OUTPUT=$(unity-editor \
    -logFile /dev/stdout \
    -quit \
    -manualLicenseFile UnityLicense.ulf)

# Store the exit code from the verify command
UNITY_EXIT_CODE=$?

# The exit code for personal activation is always 1;
# Determine whether activation was successful.
#
# Successful output should include the following:
#
#   "LICENSE SYSTEM [2020120 18:51:20] Next license update check is after 2019-11-25T18:23:38"
#
ACTIVATION_SUCCESSFUL=$(echo $ACTIVATION_OUTPUT | grep 'Next license update check is after' | wc -l)

# Set exit code to 0 if activation was successful
if [[ $ACTIVATION_SUCCESSFUL -eq 1 ]]; then
  UNITY_EXIT_CODE=0
fi;


#
# Display information about the result
#
if [ $UNITY_EXIT_CODE -eq 0 ]; then
  # Activation was a success
  echo "Activation complete."
else
  # Activation failed so exit with the code from the license verification step
  echo "Unclassified error occured while trying to activate license."
  echo "Exit code was: $UNITY_EXIT_CODE"
  exit $UNITY_EXIT_CODE
fi
