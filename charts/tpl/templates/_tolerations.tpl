{{/*
Return the range of tolerations if defined.

Example for infrastructure nodes in the values-file:
      tolerations:
        - effect: NoSchedule
          key: infra
          operator: Equal
          value: reserved
        - effect: NoSchedule
          key: infra
          operator: Equal
          value: reserved

{{ include "tpl.tolerations" . -}}
*/}}

{{- define "tpl.tolerations" -}}
tolerations:
  {{- range . }}
  - key: "{{ .key }}"
    operator: "{{ .operator }}"
    value: "{{ .value }}"
    effect: "{{ .effect }}"
    {{- if .tolerationSeconds }}
    tolerationSeconds: {{ .tolerationSeconds }}
    {{- end }}
  {{- end }}
{{- end -}}
