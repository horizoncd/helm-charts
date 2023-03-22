{{/*
Expand the name of the chart.
*/}}
{{- define "horizon.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "horizon.fullname" -}}
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
{{- define "horizon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "horizon.labels" -}}
helm.sh/chart: {{ include "horizon.chart" . }}
{{ include "horizon.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* matchLabels */}}
{{- define "horizon.matchLabels" -}}
{{ include "horizon.selectorLabels" . }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "horizon.selectorLabels" -}}
app.kubernetes.io/name: {{ include "horizon.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "horizon.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "horizon.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "horizon.core" -}}
  {{- printf "%s-core" (include "horizon.fullname" .) -}}
{{- end -}}

{{- define "horizon.job" -}}
  {{- printf "%s-job" (include "horizon.fullname" .) -}}
{{- end -}}

{{- define "horizon.config" -}}
  {{- printf "%s-config" (include "horizon.fullname" .) -}}
{{- end -}}

{{- define "horizon.roles" -}}
  {{- printf "%s-roles" (include "horizon.fullname" .) -}}
{{- end -}}

{{- define "horizon.regions" -}}
  {{- printf "%s-regions" (include "horizon.fullname" .) -}}
{{- end -}}

{{- define "horizon.swagger" -}}
  {{- printf "%s-swagger" (include "horizon.fullname" .) -}}
{{- end -}}


{{- define "horizon.scopes" -}}
  {{- printf "%s-scopes" (include "horizon.fullname" .) -}}
{{- end -}}

{{- define "horizon.authhtml" -}}
  {{- printf "%s-authhtml" (include "horizon.fullname" .) -}}
{{- end -}}

{{- define "horizon.build_schema" -}}
  {{- printf "%s-build-schema" (include "horizon.fullname" .) -}}
{{- end -}}

{{- define "horizon.web" -}}
  {{- printf "%s-web" (include "horizon.fullname" .) -}}
{{- end -}}

{{- define "horizon.dbinit" -}}
  {{- printf "%s-dbinit" (include "horizon.fullname" .) -}}
{{- end -}}

{{- define "horizon.defaultBranch" -}}
    {{- $version := (regexSplit "\\." .Values.gitlab.imageTag -1 | first | atoi) -}}
    {{- if ge $version 14 -}} {{- print "main" }} {{- else -}} {{- print "master" -}} {{- end -}}
{{- end -}}