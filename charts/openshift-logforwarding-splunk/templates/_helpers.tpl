{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "openshift-logforwarding-splunk.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "openshift-logforwarding-splunk.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "openshift-logforwarding-splunk.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "openshift-logforwarding-splunk.labels" -}}
app: {{ .Release.Name }}
helm.sh/chart: {{ include "openshift-logforwarding-splunk.chart" . }}
{{ include "openshift-logforwarding-splunk.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "openshift-logforwarding-splunk.selectorLabels" -}}
app.kubernetes.io/name: {{ include "openshift-logforwarding-splunk.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "openshift-logforwarding-splunk.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "openshift-logforwarding-splunk.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Create the name of the forwarder TLS certificate file name
*/}}
{{- define "openshift-logforwarding-splunk.certificateName" -}}
{{- if semverCompare "<1.19" (include "openshift-logforwarding-splunk.kubeVersion" .) -}}
{{- print "tls" -}}
{{- else -}}
{{- print "forwarder-tls" -}}
{{- end -}}
{{- end -}}


{{/*
Generate certificates for the fluentd forwarder. Sprig library does provide proper support
*/}}
{{- define "openshift-logforwarding-splunk.gen-fluentd-certs" -}}
{{- $fullname := include "openshift-logforwarding-splunk.fullname" . -}}
{{- $ca := genCA  (printf "%s.%s.svc" $fullname .Release.Namespace) 730 -}}
{{- $cert := genSignedCert  (printf "%s-%s.svc" $fullname .Release.Namespace) nil nil 730 $ca -}}
{{ (include "openshift-logforwarding-splunk.certificateName" .) }}.crt: {{ $cert.Cert | b64enc }}
{{ (include "openshift-logforwarding-splunk.certificateName" .) }}.key: {{ $cert.Key | b64enc }}
ca-bundle.crt: {{ $cert.Cert | b64enc }}
{{- end -}}

{{/*
Return the target Kubernetes version
*/}}
{{- define "openshift-logforwarding-splunk.kubeVersion" -}}
{{- default .Capabilities.KubeVersion.Version .Values.openshift.kubeVersion -}}
{{- end -}}

{{/*
Return the protocol for Fluentd forwarding
*/}}
{{- define "openshift-logforwarding-splunk.fluentd.protocol" -}}
{{- if .Values.forwarding.fluentd.ssl -}}
{{- print "tls" -}}
{{- else -}}
{{- print "tcp" -}}
{{- end -}}
{{- end -}}
