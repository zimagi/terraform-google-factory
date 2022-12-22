server:
  ingress:
    enabled: true
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
      nginx.ingress.kubernetes.io/auth-response-headers: "X-Auth-Request-User,X-Auth-Request-Email"
      nginx.ingress.kubernetes.io/auth-signin: "https://$host/oauth2/start?rd=$escaped_request_uri"
      nginx.ingress.kubernetes.io/auth-url: "https://$host/oauth2/auth"
    ingressClassName: nginx
    hosts:
      - ${nginx_host_name}
    paths:
      - /argocd
    tls:
      - secretName: argocd-tls
        hosts:
          - ${nginx_host_name}
    https: false
  extraArgs:
    - --insecure
    - --disable-auth
configs:
  params:
    server:
      rootpath: /argocd