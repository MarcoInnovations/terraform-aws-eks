kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: ${cluster_name}-gp2
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
reclaimPolicy: Retain