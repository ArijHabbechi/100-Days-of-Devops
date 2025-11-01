kubectl create secret generic official --from-file=/opt/official.txt
kubectl apply -f pod-secret.yaml 
kubectl exec -it secret-nautilus -c secret-container-nautilus -- ls -l /opt/apps 

