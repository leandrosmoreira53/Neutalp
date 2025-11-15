# Redeploy com USDC Correto (Arbitrum Sepolia)

## Problema
O contrato anterior foi deployado com o endereço USDC errado (Ethereum Sepolia em vez de Arbitrum Sepolia).

## Solução
Fazer redeploy com o endereço correto:
- **USDC Arbitrum Sepolia**: `0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d`

## Passos para Redeploy

### 1. Certifique-se que tem USDC Arbitrum Sepolia
Você precisa ter USDC na rede **Arbitrum Sepolia** (não Ethereum Sepolia).

**Se não tiver:**
- Bridge de Ethereum Sepolia → Arbitrum Sepolia: https://bridge.arbitrum.io/
- Ou pega faucet direto: https://www.circle.com/usdc-faucet (e muda rede pra Arbitrum Sepolia)

### 2. Execute o comando de deploy

```bash
# Defina sua private key (CUIDADO: não compartilhe!)
$env:PRIVATE_KEY = 'sua_private_key_aqui'

# Execute o deploy
forge script script/Deploy.s.sol:DeployScript \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --broadcast
```

**Ou em PowerShell:**
```powershell
$env:PRIVATE_KEY = 'sua_private_key_aqui'
forge script script/Deploy.s.sol:DeployScript --rpc-url 'https://sepolia-rollup.arbitrum.io/rpc' --broadcast
```

### 3. Copie o novo endereço do vault

Quando o deploy terminar, você verá algo como:
```
Vault deployed at: 0xNOVO_ENDERECO_AQUI
```

### 4. Atualize o frontend

No arquivo `index.html`, procure por:
```javascript
const VAULT_ADDRESS = "0x6cf5791356EEf878536Ee006f18410861D93198D";
```

E substitua pelo novo endereço:
```javascript
const VAULT_ADDRESS = "0xNOVO_ENDERECO_AQUI";
```

### 5. Recarregue o frontend

- Salve o arquivo
- Recarregue `http://localhost:8000`
- Clique em "Connect MetaMask"
- Agora tente fazer um Deposit!

## Endereços Importantes (Arbitrum Sepolia)

| Token/Contrato | Endereço |
|---|---|
| **USDC** | `0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d` |
| Chainlink BTC/USD | `0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43` |
| Uniswap v3 Position Manager | `0x1238536071E1c677A632429e3655c799b22cDA52` |
| Uniswap v3 Swap Router | `0xE592427A0AEce92De3Edee1F18E0157C05861564` |

## Troubleshooting

**Erro: "PRIVATE_KEY not found"**
- Certifique-se de setar a variável: `$env:PRIVATE_KEY = 'your_key'`

**Erro: "RPC error"**
- Verifique se tá usando o RPC correto: `https://sepolia-rollup.arbitrum.io/rpc`

**Erro: "gas estimation failed"**
- Certifique-se que a conta tem ETH Arbitrum Sepolia para pagar gas

**Erro ao fazer approve/deposit no frontend**
- O endereço do vault no frontend está desatualizado
- Atualize `VAULT_ADDRESS` no `index.html`
