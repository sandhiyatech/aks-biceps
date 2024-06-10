param location string
param clusterName string
param dnsPrefix string
param nodeCount int
param nodeVMSize string
param adminUsername string
param clientId string
param clientSecret string

var sshPublicKey = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwUhX/kKhgKv/iSLHi4Ym3dyTt+j43M/grfACAC+Bc0aM7Ls0e9HNB6H2Cfeqc5oNgWwkUFtYpsud+aqPNE4mr8VPvETFJEnZ+QjlvdUot7bWnCXJtoKt6ZdFyoMtzqBUBqkBbYf8P+NjfqWe7DAP1MIoflUOTA3m3MWyKlDJY3hxr6LeFmmBwZXu10vSZ95jkz0UfJxsYdv3LenM34yyhepZ7JYyb3arO3b8+zZ4uNkVi0Xm2xU0fdPPXO+PZGg2dIYiDHTluxSKtz3AbagVTD6241k6VDteQVI8R/skMq15/DETVQ4pCxDrR3RIq0oTm7ibrT8NDKz2uqwzA69TJHR/FEsya/QMP222xksatDjvIVZ45076azrM5B0V1bont7GmuN8RrHvNcIRiPAQVpFP9GbltHgGSA3/2cbfWj5DrZVnKgfG9mBhjlDVu6My6W/dJkrq0+U5EWRam9O9rFo2vdqSozfC8VExx2HobBq6ZUVTjProQPhABu1ctaeNU= generated-by-azure'

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
            keyData: sshPublicKey
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
