# Deployment notes
The supplied StorageClass uses `ebs.csi.aws.com` and gp3. For non-AWS clusters, change the provisioner to the platform CSI driver. Use an existing cluster with enough capacity for two frontend and two backend pods plus PostgreSQL. Tune HPA and requests to match actual node capacity.
