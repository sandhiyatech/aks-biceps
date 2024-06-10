param location string
param clusterName string
param dnsPrefix string
param nodeCount int
param nodeVMSize string
param adminUsername string
param clientId string
param clientSecret string

var sshKeyResourceName = '${clusterName}-sshkey'

var sshPublicKey = '${adminUsername}@${dnsPrefix}.com'

resource sshKey 'Microsoft.Compute/sshPublicKeys@2020-06-01' = {
  name: sshKeyResourceName
  location: location
  properties: {
    publicKey: sshPublicKey
  }
}

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
      adminUsername: adminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshKey.properties.publicKey
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
