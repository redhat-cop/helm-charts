{{/*
Return the range of resources if defined.

Example for resources in the values-file:
      resources:
        requests:
          cpu: 4
          memory: 8Gi
          ephemeral-storage: 50Mi
        limits:
          cpu: 8
          memory: 16Gi
          ephemeral-storage: 500Mi

{{ include "tpl.resources" . -}}
*/}}

{{- define "tpl.resources" -}}
resources:
  {{- if .limits }}
  limits:
    {{- if .limits.cpu }}
    cpu: {{ .limits.cpu }}
    {{- end }}
    {{- if .limits.memory }}
    {{- $memory := include "appendUnit" .limits.memory }}
    memory: {{ $memory }}
    {{- end }}
    {{- if index .limits "ephemeral-storage" }}
    {{- $ephemeral_storage := include "appendUnit" (index .limits "ephemeral-storage") }}
    ephemeral-storage: {{ $ephemeral_storage }}
    {{- end }}
  {{- end }}
  {{- if .requests }}
  requests:
    {{- if .requests.cpu }}
    cpu: {{ .requests.cpu }}
    {{- end }}
    {{- if .requests.memory }}
    {{- $memory := include "appendUnit" .requests.memory }}
    memory: {{ $memory }}
    {{- end }}
    {{- if index .requests "ephemeral-storage" }}
    {{- $ephemeral_storage := include "appendUnit" (index .requests "ephemeral-storage") }}
    ephemeral-storage: {{ $ephemeral_storage }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
Append the unit Gi if it is not set for memory or storage
*/}}
{{- define "appendUnit" -}}
{{/* Treat the value as a string */}}
{{- $val := printf "%v" . -}}
  {{- if not (hasSuffix "Gi" $val) -}}
    {{- if not (hasSuffix "Mi" $val) -}}
      {{- printf "%sGi" $val -}}
    {{- else -}}
      {{ $val -}}
    {{- end -}}
  {{- else -}}
    {{ $val -}}
  {{- end -}}
{{- end -}}
