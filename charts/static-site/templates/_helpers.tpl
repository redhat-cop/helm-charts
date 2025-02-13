
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


{{/*
Return the template of poller/updater pod
*/}}
{{- define "tmpl.pollerPodSpec" -}}
restartPolicy: Never
serviceAccountName: {{ .Release.Name }}-redeployer
volumes:
  - name: poller-script
    configMap:
      name: static-site-{{ .Release.Name }}-poller-script
      defaultMode: 0777
containers:
  - name: poller
    image: jijiechen/alpine-curl-git:v2.24.1
    imagePullPolicy: IfNotPresent
    volumeMounts:
      - mountPath: /var/poller/
        name: poller-script
    command: ["/bin/sh"]
    args:
      - /var/poller/poll.sh
    env:
      - name: REPO_URL
        value: {{ .Values.repo.location }}
      - name: BRANCH
        value: {{ .Values.repo.branch }}
    resources:
      limits:
        cpu: 200m
        memory: "200Mi"
      requests:
        cpu: 50m
        memory: "100Mi"
{{- end -}}
