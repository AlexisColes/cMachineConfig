enum MachineConfigType{
    V4x64
    V2x64
    V4x32
    V2x32
}

enum VaildationAlgoritham {
    SHA1
    MD5
    ThreeDES
    AES
    HMACSHA256
    HMACSHA384
    HMACSHA512
}

enum DecryptionAlgoritham {
    Auto
    DES
    ThreeDES
    AES    
}

[DscResource()]
class cMachineKey{
    [DscProperty(Key)]
    [MachineConfigType]$ConfigType

    [DscProperty()]
    [VaildationAlgoritham]$Validation

    [DscProperty()]
    [DecryptionAlgoritham]$Decryption

    [DscProperty()]
    [string]$ValidationKey

    [DscProperty()]
    [string]$DecryptionKey

    [bool]Test(){    
        $element = $this.GetSystemWebNode()

        if($element.GetAttribute("validation") -ne $this.Validation){
            return $false
        }
        if($element.GetAttribute("decryption") -ne $this.Decryption){
            return $false
        }
        if($element.GetAttribute("validationKey") -ne $this.ValidationKey){
            return $false
        }
        if($element.GetAttribute("decryptionKey") -ne $this.DecryptionKey){
            return $false
        }
        return $true
    }

    [void]Set(){
        $xml = $this.GetXml()
        $element = $this.GetSystemWebNode($xml)

        $element.SetAttribute("validation", $this.Validation)
        $element.SetAttribute("decryption", $this.Decryption)
        $element.SetAttribute("validationKey", $this.ValidationKey)
        $element.SetAttribute("decryptionKey", $this.DecryptionKey)

        $xml.Save($this.GetFilePath())
    }
    [cMachineKey]Get(){
        return $this
    }
    [xml]GetXml(){

        $path = $this.GetFilePath($this.ConfigType)
        
        if(-not (Test-Path $path)){
            throw "Could not find machine.config file $path"
        }
        Write-Verbose "Writing"

        return Get-Content $path        
    }
    [System.Xml.XmlElement]GetSystemWebNode(){  
        $xml = $this.GetXml()
        return $this.GetSystemWebNode($xml)
    }
    [System.Xml.XmlElement]GetSystemWebNode([xml]$xml){        

        $configElementName = "configuration"
        $configEle = $xml[$configElementName]
        if($configEle -eq $null){
            throw ("Could not find {0} node at root of config file" -f $configElementName)
        }        

        $webElementName = "system.web"
        $webElement = $configEle[$webElementName]
        if($webElement -eq $null){
            throw ("Could not find {0} node as child of {1} node" -f $webElementName, $configElementName)
        }

        $machineKeyElementName = "machineKey"
        $machineKeyElement = $webElement[$machineKeyElementName]
        if($machineKeyElement -eq $null){
            $machineKeyElement = $xml.CreateElement($machineKeyElementName)
            $webElement.AppendChild($machineKeyElement)
        }

        return $machineKeyElement
    }
    [string]GetFilePath(){
        return $this.GetFilePath($this.ConfigType)
    }
    [string]GetFilePath([MachineConfigType]$configType){
        return Join-Path $this.GetVersionDirectory($configType) "config\machine.config"
    }
    [string]GetVersionDirectory([MachineConfigType]$configType){
        
        switch ($configType){
            ([MachineConfigType]::V4x64) { return "$env:SystemRoot\Microsoft.NET\Framework64\v4.0.30319" }
            ([MachineConfigType]::V2x64) { return "$env:SystemRoot\Microsoft.NET\Framework64\v2.0.50727" }
            ([MachineConfigType]::V4x32) { return "$env:SystemRoot\Microsoft.NET\Framework\v4.0.30319" }
            ([MachineConfigType]::V2x32) { return "$env:SystemRoot\Microsoft.NET\Framework\v2.0.50727" }
            default { throw "The enum type $configType has not bee catered for"}
        }

        throw “Your enumeration is invalid. Please use one of the following values:” + [enum]::getValues([MachineConfigType])
    }
}