# Guia de Teste do DeltaNeutralVaultV1 na Testnet Arbitrum Sepolia

## Endereço do Contrato Deployado
**Vault Address**: `0x6cf5791356EEf878536Ee006f18410861D93198D`

## Pré-requisitos
1. ✅ Contrato deployado em Arbitrum Sepolia
2. ⬜ USDC na testnet (você precisa de alguns USDC Sepolia)
3. ⬜ ETH para gas na testnet

## Etapas de Teste

### 1. TESTAR DEPOSITO (Entrada de Valores)

**O que fazer:**
- Transferir USDC para o vault
- O vault converterá em shares (dnvUSDC)
- Você pode sacar shares depois

**Exemplo:**
```bash
# Valores em USDC (exemplo: 1000 USDC com 6 decimais = 1000000000)
USDC_AMOUNT = 1000000000  # 1000 USDC

# Será convertido para shares usando a taxa de conversão do vault
# Taxa inicial: 1 share = 1 USDC (ou o valor atual totalAssets/totalSupply)
```

### 2. CONFIGURAR RANGE DA POOL UNISWAP

**O que fazer:**
- Definir os ticks (tickLower e tickUpper) onde o vault vai fornecer liquidez
- O vault criará uma posição delta-neutral no Uniswap v3

**Exemplo de range:**
```
Para BTC/USD:
- Se BTC está em $50k
- tickLower = -887000 (representando preço menor, ex: $45k)
- tickUpper = -882000 (representando preço maior, ex: $55k)

Os ticks são logarítmicos no Uniswap v3
```

### 3. FORÇAR REBALANCE E CRIAR POSIÇÃO

**O que fazer:**
- Usar a função testnet_forceRebalance() para criar uma posição real no Uniswap
- O vault fornecerá liquidez com delta-neutral hedge

### 4. SIMULAR SAÍDA DO RANGE

**O que fazer:**
- Quando o preço de BTC sair do range definido:
  - O vault detecta com o oracle (Chainlink)
  - Executa auto-exit (coleta liquidity)
  - Reverte para USDC puro
  - Após estabilizar, faz auto-reenter em novo range

## Fluxo de Teste Prático

### PASSO 1: Aprovar USDC e Depositar
```solidity
// 1. Aprovar o vault para gastar USDC
USDC.approve(VAULT_ADDRESS, amount)

// 2. Depositar no vault
vault.deposit(amount, recipient)

// Resultado: você recebe shares (dnvUSDC)
```

### PASSO 2: Visualizar Estado do Vault
```solidity
// Ver quanto você tem
balanceOf(your_address)  // shares em dnvUSDC

// Ver conversão shares -> USDC
previewRedeem(shares)  // quanto USDC você pode sacar

// Ver posição no Uniswap
testnet_getPositionInfo()  // retorna tokenId, liquidity, amount0, amount1
```

### PASSO 3: Forçar Criação de Posição
```solidity
// Cria posição delta-neutral no Uniswap
// Usa USDC depositado para criar LP token
vault.testnet_forceRebalance()

// Ou defina o range primeiro:
vault.setRange(tickLower, tickUpper)  // ex: -887000, -882000
vault.testnet_forceRebalance()
```

### PASSO 4: Simular Saída do Range
```solidity
// Opção A: Simular sem fazer nada real
result = vault.testnet_simulateRebalance()
// Retorna dados sobre o que SERIA feito

// Opção B: Forçar exit (se o preço saiu do range)
vault.autoExit()  // Coleta posição, reverte para USDC

// Opção C: Forçar reenter em novo range
vault.autoReenter()  // Cria nova posição
```

## Ferramentas para Testar

### Via Etherscan (Fácil - Interface Web)
1. Vá para https://sepolia.arbiscan.io
2. Cole o endereço do vault: `0x6cf5791356EEf878536Ee006f18410861D93198D`
3. Vá na aba "Write Contract"
4. Clique em "Connect Wallet" e conecte sua carteira
5. Execute as funções:
   - `deposit` - depositar USDC
   - `withdraw` - sacar shares
   - `setRange` - definir range
   - `testnet_forceRebalance` - criar posição
   - `testnet_getPositionInfo` - ver posição

### Via Foundry (Avançado - Script)
Veja o arquivo `TEST_TESTNET.s.sol` para um script completo

### Via Cast (CLI - Intermediário)
```bash
# Ver saldo
cast call 0x6cf5791356EEf878536Ee006f18410861D93198D "balanceOf(address)" 0x90F51A05bD8DaC2d8A5b10c2930BD8415416515a \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc

# Ver total assets
cast call 0x6cf5791356EEf878536Ee006f18410861D93198D "totalAssets()" \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc

# Ver posição Uniswap
cast call 0x6cf5791356EEf878536Ee006f18410861D93198D "testnet_getPositionInfo()" \
  --rpc-url https://sepolia-rollup.arbitrum.io/rpc
```

## Valores Esperados após Testes

### Após Depositar 1000 USDC:
- totalAssets: 1000 USDC
- shares recebidas: ~1000 dnvUSDC (taxa 1:1 inicialmente)
- balanceOf: 1000 (em shares)

### Após Forçar Rebalance:
- Position criado no Uniswap com:
  - token0: ~500 USDC (ou equiv em BTC)
  - token1: ~500 USDC (ou equiv em BTC)
  - liquidity: X (número grande, uint128)
- totalAssets: ainda 1000 USDC (agora em forma de LP)

### Após Sair do Range e Auto-Exit:
- Posição coletada
- Volta para USDC puro
- Fee de rebalance deduzido (~0.3% swap fee)
- totalAssets: ~997 USDC (menos as fees)

## Próximas Etapas

1. ✅ Obter USDC Sepolia (peça em faucets)
2. ✅ Testar deposit com pequeno valor (ex: 10 USDC)
3. ✅ Ver saldo de shares
4. ✅ Definir range: `setRange(-887000, -882000)`
5. ✅ Forçar rebalance: `testnet_forceRebalance()`
6. ✅ Ver posição: `testnet_getPositionInfo()`
7. ✅ Testar withdraw: `withdraw(amount, receiver, owner)`
8. ✅ Simular saída do range: `testnet_simulateRebalance()`
9. ✅ Testar auto-exit: `autoExit()`

## Importante
- **Sempre comece com pequenos valores** para teste (ex: 1-10 USDC)
- **Use a aba "Read" do Arbiscan** para ver dados sem gastar gas
- **Guarde o hash da transação** para debug se algo der errado
- **Monitore o preço de BTC** para saber quando sai do range
