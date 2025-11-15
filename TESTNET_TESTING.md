# 🚀 TESTE NA TESTNET - GUIA PRÁTICO

## ✅ STATUS ATUAL

- **Contrato Deployado:** `0x6cf5791356EEf878536Ee006f18410861D93198D`
- **Network:** Arbitrum Sepolia (421614)
- **Status:** Pronto para testes
- **GitHub:** https://github.com/leandrosmoreira53/Neutalp

---

## 📋 PRÓXIMOS PASSOS

### 1️⃣ OBTER USDC SEPOLIA

Você precisa de USDC Sepolia para testar:

**Opção A: Faucet direto**
- Acesse: https://sepolia.arbiscan.io/address/0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238
- Procure por um método `mint()` ou faucet disponível

**Opção B: Uniswap Faucet**
- https://faucet.uniswap.org/arbitrum (se disponível)

**Opção C: Airdrop/Testnet faucets**
- Google: "Arbitrum Sepolia USDC faucet"

### 2️⃣ VISUALIZAR VAULT NO ETHERSCAN

1. Abra: https://sepolia.arbiscan.io/address/0x6cf5791356EEf878536Ee006f18410861D93198D
2. Aba **"Read Contract"** - Ver saldo, supply, etc
3. Aba **"Write Contract"** - Fazer transações (connect wallet)

### 3️⃣ TESTAR DEPÓSITO (10 USDC)

**Via Etherscan:**
1. Connect sua wallet (MetaMask com Sepolia ativo)
2. Vá para **Write Contract**
3. Procure função `deposit()`
4. Parâmetros:
   - `assets`: `10000000` (10 USDC com 6 decimais)
   - `receiver`: seu endereço

**Via Cast CLI:**
```bash
cast send 0x6cf5791356EEf878536Ee006f18410861D93198D \
  "deposit(uint256,address)" \
  10000000 \
  0xYourAddress \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --private-key $PRIVATE_KEY
```

### 4️⃣ VERIFICAR POSIÇÃO

Depois de depositar, verifique:
- Seu saldo de shares (dnvUSDC)
- Total Assets no vault
- Aprovação de USDC

**Via Etherscan - Read Contract:**
- `balanceOf(seu_endereco)` → seus shares
- `totalSupply()` → total de shares
- `totalAssets()` → USDC no vault

### 5️⃣ CONFIGURAR RANGE (Fase 2)

Quando estiver pronto:
```bash
cast send 0x6cf5791356EEf878536Ee006f18410861D93198D \
  "setRange(int24,int24)" \
  -887000 \
  -882000 \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc \
  --private-key $PRIVATE_KEY
```

---

## 🔧 OPÇÕES DE TESTE

### Opção 1: Etherscan (Mais Fácil)
✅ Sem instalar nada
✅ Interface visual
❌ Funções testnet não visíveis

### Opção 2: Cast CLI (Recomendado)
```bash
# Instalar (se não tiver)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install --git https://github.com/foundry-rs/foundry foundry-cli

# Ver nome do contrato
cast call 0x6cf5791356EEf878536Ee006f18410861D93198D \
  "name()" \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc

# Ver saldo
cast call 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238 \
  "balanceOf(address)(uint256)" \
  0x90F51A05bD8DaC2d8A5b10c2930BD8415416515a \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc
```

### Opção 3: Forge Script (Para Testes Complexos)
```bash
npm run test:vault:dry-run  # Simula sem broadcast
npm run test:vault         # Executa na testnet
```

---

## 📊 O QUE TESTAR

| Fase | Ação | Esperado | Status |
|------|------|----------|--------|
| 1 | Deposit 10 USDC | Recebe ~10 shares dnvUSDC | ⏳ Pendente |
| 2 | setRange(-887000, -882000) | Range configurado | ⏳ Pendente |
| 3 | Monitor de posição | LP criado no Uniswap | ⏳ Pendente |
| 4 | Preço sai do range | Auto-exit/reenter | ⏳ Pendente |
| 5 | Withdraw | Recebe USDC (menos fees) | ⏳ Pendente |

---

## 🔗 LINKS ÚTEIS

- **Etherscan Sepolia:** https://sepolia.arbiscan.io
- **Vault:** https://sepolia.arbiscan.io/address/0x6cf5791356EEf878536Ee006f18410861D93198D
- **USDC:** https://sepolia.arbiscan.io/address/0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238
- **Docs Deploy:** `/DEPLOY_ARBITRUM_SEPOLIA.md`
- **Código GitHub:** https://github.com/leandrosmoreira53/Neutalp

---

## ⚠️ IMPORTANTE

- **Não use mainnet!** Sempre use Sepolia
- **Testnet USDC:** Valores fictícios, use pequenas quantidades
- **Gas:** Muito barato em Sepolia (~0.001 ETH por transação)
- **Dinheiro Real:** Nunca teste com fundos reais

---

## 📝 NOTAS

- Contrato foi successfully deployado em 15 de Nov 2025
- Fees configuradas: Performance 5%, Management 2%, Swap 0.3%, Keeper 0.1%
- Entry/Exit fees zeradas (requerimento do contrato)

🎉 Bom teste!
