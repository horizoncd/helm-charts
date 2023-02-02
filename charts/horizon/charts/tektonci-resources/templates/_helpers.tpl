{{/*
define extraVolumes
*/}}
{{- define "tektonci.extraVolumes" -}}
{{- range .Values.extraVolumeMounts }}
- name: {{ .name }}
  {{- if .existingClaim }}
  persistentVolumeClaim:
    claimName: {{ .existingClaim }}
  {{- else if .hostPath }}
  hostPath:
    path: {{ .hostPath }}
  {{- else if .csi }}
  csi:
    {{- toYaml .data | nindent 6 }}
  {{- else }}
  emptyDir: {}
  {{- end }}
{{- end }}
{{- end }}

{{/*
define extraVolumeMounts
*/}}
{{- define "tektonci.extraVolumeMounts" -}}
{{- range .Values.extraVolumeMounts }}
- name: {{ .name }}
  mountPath: {{ .mountPath }}
  {{- if .subPath }}
  subPath: {{ .subPath | default "" }}
  {{- end }}
  {{- if .readOnly }}
  readOnly: {{ .readOnly }}
  {{- end }}
{{- end }}
{{- end }}