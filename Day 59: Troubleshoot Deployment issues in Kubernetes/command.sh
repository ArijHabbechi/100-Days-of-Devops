# Fix the image
kubectl patch deploy redis-deployment \
  -p='{"spec":{"template":{"spec":{"containers":[{"name":"redis-container","image":"redis:alpine"}]}}}}'

# Fix the ConfigMap name in the volume
kubectl patch deploy redis-deployment \
  --type='json' \
  -p='[{"op":"replace","path":"/spec/template/spec/volumes/1/configMap/name","value":"redis-config"}]'

kubectl rollout status deploy/redis-deployment
