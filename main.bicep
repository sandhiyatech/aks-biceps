// main.bicep

// Parameters
param location string = resourceGroup().location
param clusterName string
param dnsPrefix string
param agentPoolName string = 'agentpool'
param agentCount int = 3
param agentVMSize string = 'Standard_DS2_v2'
param k8sVersion string = '1.23.12'  // specify a valid Kubernetes version

// AKS Cluster
resource aksCluster 'Microsoft.ContainerService/managedClusters@2022-09-01' = {
  name: clusterName
  location: location
  properties: {
    dnsPrefix: dnsPrefix
    kubernetesVersion: k8sVersion
    agentPoolProfiles: [
      {
        name: agentPoolName
        count: agentCount
        vmSize: agentVMSize
        mode: 'System'
      }
    ]
    enableRBAC: true
    networkProfile: {
      networkPlugin: 'azure'
    }
  }
}

// Output the kubeconfig
output kubeConfig string = listCredentials(aksCluster.id, '2022-09-01').kubeconfigs[0].value
