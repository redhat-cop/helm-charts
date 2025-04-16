{{/*
Expand the name of the chart.
*/}}
{{- define "operators-installer.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "operators-installer.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "operators-installer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "operators-installer.labels" -}}
helm.sh/chart: {{ include "operators-installer.chart" . }}
{{ include "operators-installer.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.commonLabels }}
{{ .Values.commonLabels | toYaml }}
{{- end }}
{{- if ((.Values.global).commonLabels) }}
{{ .Values.global.commonLabels | toYaml }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "operators-installer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "operators-installer.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Name to use for approver SA, Role, and RoleBinding
*/}}
{{- define "operators-installer.approverName" -}}
{{- printf "%s-%s" .csv "approver" | trunc -63 | replace "." "-" | trimAll "-" }}
{{- end }}

{{/*
Name to use for the ConfigMap that will store the scripts for installPlan approval, verification, etc.
*/}}
{{- define "operators-installer.scriptsName" -}}
{{- printf "%s-%s" .csv "scripts" | trunc -63 | replace "." "-" | trimAll "-" }}
{{- end }}
