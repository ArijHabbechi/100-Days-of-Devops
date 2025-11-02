# 1. List all pods to check if the Python app pod is running or failing
kubectl get po  

# 2. Check the deployment status — ensures the deployment exists and shows replicas and image
kubectl get deployment 

# 3. Inspect deployment details to identify misconfiguration (wrong image, container name, etc.)
kubectl describe deployment python-deployment-datacenter

# 6. Fix the deployment by patching it with the correct image for the Flask app
#    This replaces the container image to 'poroko/flask-demo-app'
kubectl patch deploy python-deployment-datacenter \
  -p='{"spec":{"template":{"spec":{"containers":[{"name":"python-container-datacenter","image":"poroko/flask-demo-app"}]}}}}'

# 7. Wait for the rollout to complete successfully after patching
kubectl rollout status deploy/python-deployment-datacenter

# 8. Check the existing services to verify the app’s service configuration
kubectl get svc 

# 9. Describe the service to see current ports (port, targetPort, nodePort)
kubectl describe svc python-service-datacenter

# 10. Fix the service configuration by patching correct ports:
#     - 'port': 8080 (service port)
#     - 'targetPort': 5000 (Flask’s default port)
#     - 'nodePort': 32345 (as required)
kubectl patch svc python-service-datacenter \
  -p '{"spec": {"ports": [{"port": 8080, "targetPort": 5000, "nodePort": 32345}]}}'
