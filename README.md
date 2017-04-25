# cMachineConfig
Dsc resource for managing your machine.config file

Only contains one resource so far for updating your machineKey.

Config type refers to the particular machine.config file you wish the resource to act upon

valid values are as follows:
"V4x64" - .net framework v4 64 bit
"V4x32" - .net framework v4 32 bit
"V2x64" - .net framework v2 64 bit
"V2x32" - .net framework v2 32 bit

cMachineKey V4x64 {
    ConfigType = V4x64
    Validation = "SHA1"
    ValidationKey = "DF7D6481DB38DBD458C4BE738A8C8AAB82B0D3B2ADC42A0C7FFD8E6B04C38BA957710F5653234B8D69B1B98057EABBAF62A66C0FEE82B76607724F56A6A6BCEF"
    Decryption = "AES"
    DecryptionKey = "55CDFB6B218A7984AEE8F19D2CB25BA35C8A60628DCFD905460D4A6D67E322F1"
}
