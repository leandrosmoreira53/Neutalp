# Setup e Compilação - DeltaNeutralVaultV1

## Pré-requisitos

- Foundry (forge, cast, anvil)
- Node.js v18+ (para dependências npm)
- npm ou yarn
- Git

## Instalação

### 1. Instalar Foundry

```bash
# Instalar foundryup
curl -L https://foundry.paradigm.xyz | bash

# Instalar forge, cast, anvil
foundryup
```

### 2. Verificar Instalação

```bash
forge --version
cast --version
anvil --version
```

### 3. Navegue até o diretório do projeto

```bash
cd "Modulo 03 Desenvolvimento com Solidity/DeltaNeutralVault"
```

### 4. Instale as dependências

```bash
npm install
```

Isso instalará:
- OpenZeppelin Contracts (ERC20, ERC4626, etc.)
- Chainlink Contracts (Price Feeds)
- Uniswap v3 (para Etapa 2)

### 5. Instalar Forge Std (se necessário)

```bash
forge install foundry-rs/forge-std --no-commit
```

## Compilação

Para compilar o contrato:

```bash
npm run compile
```

Ou diretamente:

```bash
forge build
```

O contrato compilado estará em `out/DeltaNeutralVaultV1.sol/DeltaNeutralVaultV1.json`

## Verificação da Implementação

### Checklist de Funcionalidades Implementadas

✅ **Estrutura Base**
- [x] Herança ERC20
- [x] Herança ERC4626
- [x] Herança Ownable
- [x] Herança Pausable
- [x] Herança ReentrancyGuard

✅ **Variáveis de Storage**
- [x] Roles (keeper, treasury)
- [x] 6 tipos de fees (bps)
- [x] Oracle Chainlink (feed, deviation, delay)
- [x] Uniswap v3 placeholders (pool, ticks)
- [x] Accounting (timestamp, high water mark)

✅ **Funções de Configuração (onlyOwner)**
- [x] setUniswapPool
- [x] setRange
- [x] setKeeper
- [x] setOracles
- [x] setSlippageParams
- [x] setTreasury
- [x] setFees (unificada)
- [x] pause / unpause

✅ **Funções de Fee**
- [x] _chargeEntryFee
- [x] _chargeExitFee
- [x] _chargeManagementFee
- [x] _chargePerformanceFee
- [x] _applySwapFee
- [x] Integração em deposit/withdraw/redeem

✅ **Funções do Keeper**
- [x] modifier onlyKeeper
- [x] autoExit (com validação oracle e performance fee)
- [x] autoReenter (com validação oracle)
- [x] recordHedgeState
- [x] updateAccounting

✅ **Funções Core (Stubs)**
- [x] _openPosition (stub para Etapa 2)
- [x] _closePositionAndConvertToUSDC (stub para Etapa 2)
- [x] executeSwap (stub para Etapa 2)
- [x] emergencyExitToUSDC

✅ **Oracle Chainlink**
- [x] _getOraclePrice
- [x] _checkOracle (validação de preço, staleness, deviation)

✅ **Overrides ERC4626**
- [x] deposit (com entry fee)
- [x] withdraw (com exit fee)
- [x] redeem (com exit fee)
- [x] totalAssets

✅ **Eventos**
- [x] 15+ eventos para todas as operações importantes

## Estrutura de Código

```
DeltaNeutralVaultV1.sol (726 linhas)
├── Imports (OpenZeppelin + Chainlink)
├── Enums (ExitReason)
├── Variáveis de Storage
├── Eventos
├── Modifiers (onlyKeeper)
├── Construtor
├── Funções de Configuração (8 funções)
├── Funções de Fee (5 funções internas)
├── Oracle Chainlink (2 funções)
├── Funções do Keeper (4 funções)
├── Funções Core Stubs (3 funções)
├── Emergency Exit (1 função)
└── Overrides ERC4626 (4 funções)
```

## Análise de Gas (estimativas)

| Operação | Gas Estimado | Notas |
|----------|--------------|-------|
| Deploy | ~3.500.000 | Inclui herança ERC4626 |
| deposit() | ~150.000 | Com entry fee |
| withdraw() | ~120.000 | Com exit fee |
| autoExit() | ~200.000 | Etapa 1 (sem Uniswap) |
| autoReenter() | ~180.000 | Etapa 1 (sem Uniswap) |

**Nota**: Valores reais da Etapa 2 (com Uniswap v3) serão significativamente maiores.

## Testes

Os testes estão implementados usando Foundry:

```
test/
└── DeltaNeutralVault.t.sol    # Testes completos em Solidity
```

Para rodar os testes:

```bash
# Todos os testes
npm run test

# Ou diretamente
forge test

# Com verbosidade
forge test -vvv

# Com relatório de gas
forge test --gas-report
```

Para mais detalhes sobre testes, consulte [FOUNDRY.md](./FOUNDRY.md)

## Próximos Passos

1. **Validar Compilação**
   ```bash
   npm run compile
   # ou
   forge build
   ```
   Deve compilar sem erros.

2. **Rodar Testes**
   ```bash
   forge test
   ```
   Todos os testes devem passar.

3. **Revisar Contrato**
   - Verificar todas as funções implementadas
   - Conferir eventos emitidos
   - Validar modificadores de acesso

4. **Deploy (quando necessário)**
   - Use os scripts Foundry em `script/`
   - Consulte `FOUNDRY.md` para mais detalhes

## Troubleshooting

### Erro: "Cannot find module '@openzeppelin/contracts'"

```bash
npm install @openzeppelin/contracts
```

### Erro: "Cannot find module '@chainlink/contracts'"

```bash
npm install @chainlink/contracts
```

### Erro: "forge-std not found"

```bash
forge install foundry-rs/forge-std --no-commit
```

### Erro de compilação relacionado a Solidity version

Certifique-se de que está usando Solidity 0.8.20 no `foundry.toml`:
```toml
solc_version = "0.8.20"
```

### Erro: "forge: command not found"

Instale o Foundry:
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

## Recursos Adicionais

- [OpenZeppelin ERC4626](https://docs.openzeppelin.com/contracts/4.x/erc4626)
- [Chainlink Price Feeds](https://docs.chain.link/data-feeds)
- [Uniswap v3 Documentation](https://docs.uniswap.org/protocol/introduction)
- [Foundry Documentation](https://book.getfoundry.sh/)
- [Foundry Testing Guide](./FOUNDRY.md)

## Suporte

Para dúvidas ou problemas:
1. Verifique a documentação no README.md
2. Revise este guia de setup
3. Consulte os links de recursos adicionais

---

**Status**: ✅ Etapa 1 completa e pronta para compilação
**Próximo**: Etapa 2 - Integração completa com Uniswap v3
