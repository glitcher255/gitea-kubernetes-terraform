#helm search repo grafana/loki
resource "kubernetes_manifest" "letsencrypt_staging" {
  manifest = yamldecode(file("${path.module}/../../helm_values/cluster-issuer/cluster-issuer.yaml"))
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  namespace  = var.monitoring_namespace
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.18.2"
  values     = [file("${path.module}/../../helm_values/cert-manager/values.yaml")]
}

resource "helm_release" "ingress-nginx" {
  name       = "ingress-nginx"
  namespace  = var.monitoring_namespace
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.13.0"
  values     = [file("${path.module}/../../helm_values/ingress-nginx/values.yaml")]
  depends_on = [ helm_release.cert-manager ]
}

resource "helm_release" "tempo" {
  name       = "tempo"
  namespace  = var.monitoring_namespace
  repository = "https://grafana.github.io/helm-charts"
  chart      = "tempo"
  version    = "1.23.2"
  values     = [file("${path.module}/../../helm_values/tempo/values.yaml")]
}

resource "helm_release" "prometheus_stack" {
  name       = "monitoring"
  namespace  = var.monitoring_namespace
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "75.13.0"
  values     = [file("${path.module}/../../helm_values/grafana/values.yaml")]
  depends_on = [ helm_release.ingress-nginx ]
}

resource "helm_release" "loki" {
  name       = "loki"
  namespace  = var.monitoring_namespace
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "6.32.0"
  values     = [file("${path.module}/../../helm_values/loki/values.yaml")]
}

resource "helm_release" "otel_collector" {
  name       = "otel-collector"
  namespace  = var.monitoring_namespace
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  version    = "0.129.0"
  values     = [file("${path.module}/../../helm_values/otel/values.yaml")]
}

resource "helm_release" "gitea" {
  name       = "gitea"
  namespace  = var.monitoring_namespace
  repository = "https://dl.gitea.io/charts"
  chart      = "gitea"
  version    = "12.1.2"
  values     = [file("${path.module}/../../helm_values/gitea/values.yaml")]
}