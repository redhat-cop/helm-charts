{{/*
Get the password to use to access MinIO&reg;
*/}}
{{- define "minio.secret.passwordValue" -}}
{{- if .Values.auth.rootPassword }}
    {{- .Values.auth.rootPassword -}}
{{/* {{- else if (not .Values.auth.forcePassword) }}
    {{- include "getValueFromSecret" (dict "Namespace" .Release.Namespace "Name" (include "common.names.fullname" .) "Length" 10 "Key" "root-password")  -}}
*/}}
{{- else -}}
    {{ required "A root password is required!" .Values.auth.rootPassword }}
{{- end -}}
{{- end -}}

{{/*
Get the credentials secret.
*/}}
{{- define "minio.secretName" -}}
{{- if .Values.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.auth.existingSecret $) -}}
{{/* {{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
*/}}
{{- end -}}
{{- end -}}

{{/*
Get the root user key.
*/}}
{{- define "minio.rootUserKey" -}}
{{- if and (.Values.auth.existingSecret) (.Values.auth.rootUserSecretKey) -}}
    {{- printf "%s" (tpl .Values.auth.rootUserSecretKey $) -}}
{{- else -}}
    {{- "root-user" -}}
{{- end -}}
{{- end -}}

{{/*
Get the root password key.
*/}}
{{- define "minio.rootPasswordKey" -}}
{{- if and (.Values.auth.existingSecret) (.Values.auth.rootPasswordSecretKey) -}}
    {{- printf "%s" (tpl .Values.auth.rootPasswordSecretKey $) -}}
{{- else -}}
    {{- "root-password" -}}
{{- end -}}
{{- end -}}


{{- define "provisioner.randomString" -}}
{{ randAlphaNum . }}
{{- end -}}
