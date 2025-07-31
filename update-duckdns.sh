# MAKE SURE NAMESPACE IS CORRECT
DOMAIN="glitcher-gitea"
NAMESPACE="monitoring"
SERVICE="traefik"
MAX_TRIES=20
SLEEP_SEC=3
VAULT_NAME="your-keyvault-name"
SECRET_NAME="duckdns-token"

# Get token from Azure Key Vault
DUCKDNS_TOKEN=$(az keyvault secret show --vault-name "$VAULT_NAME" --name "$SECRET_NAME" --query "value" -o tsv)

# Get IP (retry loop only, no branching logic)
COUNT=0
while [ "$COUNT" -lt "$MAX_TRIES" ]; do
  IP=$(kubectl get svc "$SERVICE" -n "$NAMESPACE" -o jsonpath="{.status.loadBalancer.ingress[0].ip}" 2>/dev/null || true)
  echo "Attempt $COUNT: IP = $IP"
  test -n "$IP" && break
  sleep "$SLEEP_SEC"
  COUNT=$((COUNT + 1))
done

# Update DuckDNS
curl -s "https://www.duckdns.org/update?domains=${DOMAIN}&token=${DUCKDNS_TOKEN}&ip=${IP}&verbose=true"