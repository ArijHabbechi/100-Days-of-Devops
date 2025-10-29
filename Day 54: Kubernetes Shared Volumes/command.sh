kubectl exec -it volume-share-xfusion -c volume-container-xfusion-1 -- sh -c 'echo "Volume test" > /tmp/beta/beta.txt'
kubectl exec -it volume-share-xfusion -c volume-container-xfusion-2 -- sh -c 'cat /tmp/cluster/beta.txt'
