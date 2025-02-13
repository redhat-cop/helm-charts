{{/*
Create the name of the service account to use.
If not set use "temp-serviceaccount" to ensure
that templating works and does not break at some point
*/}}
{{- define "tpl.serviceAccountName" -}}
  {{- if .Values.serviceAccount.create }}
    {{- default .Values.serviceAccount.name }}
  {{- else }}
    {{- default "temp-serviceaccount" }}
  {{- end }}
{{- end }}


{{/*
Create the name of the service account to use.
If not set use "temp-serviceaccount" to ensure
that templating works and does not break at some point
*/}}
{{- define "tpl.serviceAccount" -}}
  {{- if .create }}
    {{- default .name }}
  {{- else }}
    {{- default "temp-serviceaccount" }}
  {{- end }}
{{- end }}
