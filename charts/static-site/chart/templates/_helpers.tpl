
{{/*
Return the proper Storage Class
*/}}
{{- define "tmpl.storageClass" -}}
{{- if .Values.persistence.storage.storageClass -}}
    {{- if (eq "-" .Values.persistence.storage.storageClass) -}}
        {{- printf "storageClassName: \"\"" -}}
    {{- else }}
        {{- printf "storageClassName: %s" .Values.persistence.storage.storageClass -}}
    {{- end -}}
{{- end -}}
{{- end -}}

