{{/*
Create a sleeptimer for Jobs.
This has no input parameters. It just prints our the below while loop.

{{ include "tpl.sleeptimer" . -}}
*/}}
{{- define "tpl.sleeptimer" -}}
sleep_timer={{ .sleeptimer | default 20 }}

SLEEPER_TMP=1
SLEEPER_MOD=10

while [[ $SLEEPER_TMP -le "$sleep_timer" ]]; do
  if (( $SLEEPER_TMP % 10 == 0 ))
  then
    echo -n "$SLEEPER_MOD"
    SLEEPER_MOD=$(($SLEEPER_MOD+10))
  else
    echo -n "."
  fi
  sleep 1
  SLEEPER_TMP=$(($SLEEPER_TMP+1))
done
{{- end -}}
