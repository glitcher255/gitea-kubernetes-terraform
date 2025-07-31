kubectl create namespace monitoring

helm repo add jetstack https://charts.jetstack.io
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add traefik https://traefik.github.io/charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo add gitea https://dl.gitea.io/charts
helm repo update

#helm upgrade --install cert-manager jetstack/cert-manager --namespace monitoring --version 1.14.4 --set installCRDs=true -f helm_values/cert-manager/values.yaml
#kubectl apply -f helm_values/cluster-issuer/cluster-issuer.yaml
#helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace monitoring --version 4.13.0 -f helm_values/ingress-nginx/values.yaml
#kubectl apply -f helm_values/ingress-nginx/catch-all.yaml

kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml

helm upgrade --install traefik traefik/traefik --namespace monitoring -f helm_values/traefik/values.yaml

kubectl apply -f helm_values/traefik/middleware.yaml

#helm upgrade --install tempo grafana/tempo --namespace monitoring --version 1.23.2 -f helm_values/tempo/values.yaml

helm upgrade --install monitoring prometheus-community/kube-prometheus-stack --namespace monitoring --version 75.13.0 -f helm_values/grafana/values.yaml
kubectl apply -f helm_values/ingress-routes/grafana-ingress.yaml --namespace monitoring

#helm upgrade --install loki grafana/loki --namespace monitoring --version 6.32.0 -f helm_values/loki/values.yaml

#helm upgrade --install otel-collector open-telemetry/opentelemetry-collector --namespace monitoring --version 0.129.0 -f helm_values/otel/values.yaml

helm upgrade --install gitea gitea/gitea --namespace monitoring --version 12.1.2 -f helm_values/gitea/values.yaml
kubectl apply -f helm_values/ingress-routes/gitea-ingress.yaml --namespace monitoring

echo
echo "✅ All apps deployed to namespace 'monitoring'"

#az aks get-credentials --resource-group RG_main --name AKS_cluster --overwrite-existing
#bash deploy-apps.sh
