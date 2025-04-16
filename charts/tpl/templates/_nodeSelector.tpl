{{/*
Set a nodeSelctor

Example for resources in the values-file:
      nodeSelector:
        key: node-role.kubernetes.io/infra
        value: ''

{{ include "tpl.nodeSelector" . -}}
*/}}

{{- define "tpl.nodeSelector" -}}
  {{- if .nodeSelector }}
  nodeSelector:
    matchLabels:
      {{ .nodeSelector.key }}: {{ .nodeSelector.value | quote }}
  {{- end }}
{{- end -}}
