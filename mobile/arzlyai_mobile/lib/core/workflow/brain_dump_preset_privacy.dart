const brainDumpPresetKey = 'brain-dump-to-action';

bool isBrainDumpWorkflowKey(String key) => key == brainDumpPresetKey;

bool brainDumpSyncEnabled(Map<String, String> inputs) =>
    inputs['syncTasks'] == 'true' ||
    inputs['syncCalendar'] == 'true' ||
    inputs['sendEmail'] == 'true';

Object brainDumpSafeError(Object error) {
  const message = 'Brain dump workflow request failed.';
  return StateError(message);
}
