# Default values for test.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

common:
  applications:
    metadata:
      namespace: "argocd"
    source:
      extraSourceFields: {}
    extraFields: {}

applications:
  zimagi:
    enabled: true
    metadata:
      applicationName: "zimagi"
      annotations: {}
    source:
      chart: "zimagi"
      repoURL: "https://zimagi.github.io/charts"
      targetRevision: "1.0.62"
      helm:
        releaseName: "zimagi"
        values: |
          service:
            commandApi:
              type: LoadBalancer
            dataApi:
              type: LoadBalancer
        skipCrds: false
      extraSourceFields: {}
    destination:
      namespace: "zimagi"
    extraFields: {}
    syncOptions:
      replace: false

  nfsGaneshaServer:
    enabled: true
    metadata:
      applicationName: "nfs-server-provisioner"
      annotations: {}
    source:
      chart: "nfs-server-provisioner"
      repoURL: "https://kubernetes-sigs.github.io/nfs-ganesha-server-and-external-provisioner"
      targetRevision: "1.4.0"
      helm:
        releaseName: "nfs-server-provisioner"
        values: {}
        skipCrds: false
      extraSourceFields: {}
    destination:
      namespace: "nfs-server-provisioner"
    extraFields: {}
    syncOptions:
      replace: false

  kube-prometheus-stack:
    enabled: true
    metadata:
      applicationName: "kube-prometheus-stack"
      annotations: {}
    source:
      chart: "kube-prometheus-stack"
      repoURL: "https://prometheus-community.github.io/helm-charts"
      targetRevision: "41.9.1"
      helm:
        releaseName: "kube-prometheus-stack"
        values: |
          grafana:
            ingress:
              enabled: true
              hosts:
                - ${nginx_host_name}
              tls:
                - secretName: grafana-tls
                  hosts:
                    - ${nginx_host_name}
              path: "/grafana"
              annotations:
                cert-manager.io/issuer-name: letsencrypt-prod
                nginx.ingress.kubernetes.io/auth-response-headers: "X-Auth-Request-User,X-Auth-Request-Email"
                nginx.ingress.kubernetes.io/auth-signin: "https://$host/oauth2/start?rd=$escaped_request_uri"
                nginx.ingress.kubernetes.io/auth-url: "https://$host/oauth2/auth"
              ingressClassName: nginx
            grafana.ini:
              server:
                root_url: "%(protocol)s://%(domain)s:%(http_port)s/grafana"
                domain: "${nginx_host_name}"
                serve_from_sub_path: true
              auth.basic:
                enabled: false
              auth.anonymous:
                enabled: true
        skipCrds: true
      extraSourceFields: {}
    destination:
      namespace: "kube-prometheus-stack"
    extraFields: {}
    syncOptions:
      replace: false

  kube-prometheus-stack-crds:
    enabled: true
    metadata:
      applicationName: "kube-prometheus-stack-crds"
      annotations: {}
    source:
      path: charts/kube-prometheus-stack/crds
      repoURL: "https://github.com/prometheus-community/helm-charts.git"
      targetRevision: "kube-prometheus-stack-41.9.1"
      extraSourceFields: {}
    destination:
      namespace: "kube-prometheus-stack"
    extraFields: {}
    syncOptions:
      replace: true

  elasticsearch:
    enabled: true
    metadata:
      applicationName: "elasticsearch"
      annotations: {}
    source:
      chart: "elasticsearch"
      repoURL: "https://helm.elastic.co"
      targetRevision: "7.17.3"
      helm:
        releaseName: "elasticsearch"
        values: {}
        skipCrds: false
      extraSourceFields: {}
    destination:
      namespace: "elastic-system"
    extraFields: {}
    syncOptions:
      replace: false

  kibana:
    enabled: true
    metadata:
      applicationName: "kibana"
      annotations: {}
    source:
      chart: "kibana"
      repoURL: "https://helm.elastic.co"
      targetRevision: "7.17.3"
      helm:
        releaseName: "kibana"
        values: |
            ingress:
              enabled: true
              className: "nginx"
              annotations:
                cert-manager.io/issuer-name: letsencrypt-prod
                nginx.ingress.kubernetes.io/auth-response-headers: "X-Auth-Request-User,X-Auth-Request-Email"
                nginx.ingress.kubernetes.io/auth-signin: "https://$host/oauth2/start?rd=$escaped_request_uri"
                nginx.ingress.kubernetes.io/auth-url: "https://$host/oauth2/auth"
              pathtype: ImplementationSpecific
              hosts:
                - host: ${nginx_host_name}
                  paths:
                    - path: /kibana
              tls:
                - secretName: kibana-tls
                  hosts:
                    - ${nginx_host_name}
            kibanaConfig:
              kibana.yml: |
                server.basePath: /kibana
                server.rewriteBasePath: true
                xpack.security.enabled: false
            healthCheckPath: /kibana
        skipCrds: false
      extraSourceFields: {}
    destination:
      namespace: "elastic-system"
    extraFields: {}
    syncOptions:
      replace: false

  filebeat:
    enabled: true
    metadata:
      applicationName: "filebeat"
      annotations: {}
    source:
      chart: "filebeat"
      repoURL: "https://helm.elastic.co"
      targetRevision: "7.17.3"
      helm:
        releaseName: "filebeat"
        values: {}
        skipCrds: false
      extraSourceFields: {}
    destination:
      namespace: "elastic-system"
    extraFields: {}
    syncOptions:
      replace: false

  cert-manager:
    enabled: true
    metadata:
      applicationName: "cert-manager"
      annotations: {}
    source:
      chart: "cert-manager"
      repoURL: "https://charts.jetstack.io"
      targetRevision: "1.10.0"
      helm:
        releaseName: "cert-manager"
        values: |
          installCRDs: true
        skipCrds: false
      extraSourceFields: {}
    destination:
      namespace: "cert-manager"
    extraFields: {}
    syncOptions:
      replace: false

  cert-manager-letsencrypt:
    enabled: true
    metadata:
      applicationName: "cert-manager-letsencrypt"
      annotations: {}
    source:
      chart: "cert-manager-letsencrypt"
      repoURL: "https://radar-base.github.io/radar-helm-charts"
      targetRevision: "0.1.0"
      helm:
        releaseName: "cert-manager-letsencrypt"
        values:
          maintainerEmail: ${maintainer_email}
        skipCrds: false
      extraSourceFields: {}
    destination:
      namespace: "cert-manager"
    extraFields: {}
    syncOptions:
      replace: false

  nginx-ingress-controller:
    enabled: true
    metadata:
      applicationName: "nginx-ingress-controller"
      annotations: {}
    source:
      chart: "nginx-ingress-controller"
      repoURL: "https://charts.bitnami.com/bitnami"
      targetRevision: "9.3.21"
      helm:
        releaseName: "nginx-ingress-controller"
        values: {}
        skipCrds: false
      extraSourceFields: {}
    destination:
      namespace: "nginx-ingress-controller"
    extraFields: {}
    syncOptions:
      replace: false

  oauth2-proxy:
    enabled: true
    metadata:
      applicationName: "oauth2-proxy"
      annotations: {}
    source:
      chart: "oauth2-proxy"
      repoURL: "https://oauth2-proxy.github.io/manifests"
      targetRevision: "6.4.0"
      helm:
        releaseName: "oauth2-proxy"
        values: |
          config:
            clientID: "${client_id}"
            clientSecret: "${client_secret}"
            cookieSecret: "n+UTxIKw/Jm/M+SczcSONw=="
          ingress:
            annotations:
              cert-manager.io/cluster-issuer: letsencrypt-prod
            tls:
              - secretName: oauth2-proxy-tls
                hosts:
                  - ${nginx_host_name}
            enabled: true
            className: "nginx"
            hosts:
              - ${nginx_host_name}
            path: /oauth2
        skipCrds: false
      extraSourceFields: {}
    destination:
      namespace: "oauth2-proxy"
    extraFields: {}
    syncOptions:
      replace: false
