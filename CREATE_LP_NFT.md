# 📍 Como Gerar o NFT da Posição LP no Arbitrum Sepolia

## Status Atual

- **Vault:** ✅ Configurado
- **Pool:** ✅ Criado (0xB5AD58CBcc1a9DB06A9852b20aEc95FF3ba56F3a)
- **Range:** ✅ Setado [-530700, -528300]
- **Liquidity:** ❌ 0 (nenhuma posição criada)

---

## Problema

Para criar uma posição LP (NFT), você precisa de **AMBOS os tokens**:
- WBTC: ✅ Você tem 10 WBTC
- USDC: ❌ Você tem 0 USDC (foi gasto no deposit anterior)

---

## Solução: 3 Passos Simples

### Step 1: Obtenha USDC no Arbitrum Sepolia Testnet

Você precisa de USDC testnet. Escolha uma opção:

**Opção A - Bridge (Recomendado)**
- Se você tem USDC em Ethereum Sepolia, faça bridge para Arbitrum Sepolia usando:
  - https://bridge.arbitrum.io/
  - Use o Stargate Bridge
  
**Opção B - Faucet**
- Procure por um testnet faucet que tenha USDC Arbitrum Sepolia
- Exemplo sites: Alchemy Faucet, Chainlink Faucet, etc

**Opção C - Pedir em comunidades**
- Discord Arbitrum dev communities
- Uniswap discord

---

### Step 2: Execute o Script de Criação do NFT

Uma vez que você tenha USDC, execute:

```bash
cd c:\DeltaNeutralVault

# Script que você pode usar quando tiver USDC
forge script script/CreateLPPosition.s.sol --rpc-url https://sepolia-rollup.arbitrum.io/rpc --broadcast
```

---

### Step 3: Veja seu NFT no Arbiscan

Depois da execução, você verá:
- **Token ID:** seu ID único do NFT

Veja em:
```
https://sepolia.arbiscan.io/nft/0x6b2937Bde17889EDCf8fbD8dE31C3C2a70Bc4d65/{TOKEN_ID}
```

---

## Por que isso é necessário?

1. **O vault armazena USDC** (não WBTC)
2. **Você tem WBTC** (do mint anterior)
3. **Para criar LP** precisa de ambos
4. **Você precisa conseguir USDC testnet** para balancear

---

## Cenário Alternativo: Usar a UI

Se você quer evitar scripts e usar apenas a UI:

1. **Obtenha USDC** (siga Step 1 acima)
2. **Vá para a UI (index.html)**
3. **Conecte MetaMask** com sua conta
4. **Faça um depósito** de USDC (não importa a quantidade, até 0.1 USDC)
5. **Clique "Withdraw"** para sacar seus fundos em USDC
6. **Agora você tem USDC!** Execute o script do Step 2

---

## Tokens Testnet Disponíveis

- **USDC:** 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d
- **WBTC Mock:** 0xEf39185d82F3Dd98046107D6Ca9bA2AF77a2B5dF (você tem 10)
- **Pool:** 0xB5AD58CBcc1a9DB06A9852b20aEc95FF3ba56F3a

---

## Verificar Balances

```bash
# Seu USDC
cast call 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d \
  "balanceOf(address)(uint256)" 0x90F51A05bD8DaC2d8A5b10c2930BD8415416515a \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc

# Seu WBTC
cast call 0xEf39185d82F3Dd98046107D6Ca9bA2AF77a2B5dF \
  "balanceOf(address)(uint256)" 0x90F51A05bD8DaC2d8A5b10c2930BD8415416515a \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc
```

---

## Status do NFT Depois de Criado

Você verá no Arbiscan:
- **NFT ID:** seu token único
- **Ticks:** -530700 to -528300
- **Pool:** USDC/WBTC 0.3%
- **Liquidity:** seu valor

---

**Próximo passo:** Obtenha USDC testnet e execute o script!
