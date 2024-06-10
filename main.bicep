param location string = resourceGroup().location
param clusterName string = 'myAKSCluster'
param dnsPrefix string = 'myakscluster'
param nodeCount int = 1
param nodeVMSize string = 'Standard_DS2_v2'
param clientId string
param clientSecret string

resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-01-01' = {
  name: clusterName
  location: location
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: nodeCount
        vmSize: nodeVMSize
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: 'azureuser'
      ssh: {
        publicKeys: [
          {
            keyData: 'your-ssh-public-key'
          }
        ]
      }
    }
    servicePrincipalProfile: {
      clientId: clientId
      secret: clientSecret
    }
    enableRBAC: true
    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'standard'
    }
  }
}

output kubeConfigCommand string = 'az aks get-credentials --resource-group ${resourceGroup().name} --name ${clusterName}'
