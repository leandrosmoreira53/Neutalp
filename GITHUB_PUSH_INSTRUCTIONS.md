# Instruções para fazer Push no GitHub

## Opção 1: Usar GitHub CLI (Recomendado)

```powershell
# Instalar GitHub CLI se não tiver
choco install gh

# Autenticar
gh auth login

# Configurar remote
cd C:\DeltaNeutralVault
git remote add origin https://github.com/leandrosmoreira53/DeltaNeutralVault.git

# Fazer push
git push -u origin main
```

## Opção 2: Usar Personal Access Token

1. Acesse: https://github.com/settings/tokens
2. Clique em "Generate new token" → "Generate new token (classic)"
3. Selecione scopes: `repo`, `gist`, `workflow`
4. Copie o token
5. Execute:

```powershell
cd C:\DeltaNeutralVault
git remote add origin https://YOUR_TOKEN@github.com/leandrosmoreira53/DeltaNeutralVault.git
git push -u origin main
```

## Opção 3: Configurar Git Credentials

```powershell
# Configure uma vez
git config --global credential.helper manager-core

cd C:\DeltaNeutralVault
git remote add origin https://github.com/leandrosmoreira53/DeltaNeutralVault.git
git push -u origin main

# Na primeira vez, será pedido username e token (use token como senha)
```

## Status Atual

✅ Repositório local inicializado  
✅ Todos os arquivos adicionados e commitados  
❌ Remote não configurado (precisa de autenticação)

## Commit realizado:

```
commit: "Add testnet testing scripts (TestVault.s.sol, CheckVault.s.sol) and update npm scripts with Foundry commands"

Mudanças incluídas:
- script/TestVault.s.sol (novo)
- script/CheckVault.s.sol (novo)
- package.json (atualizado com npm scripts)
- Todos os arquivos do projeto (primeira vez)
```

## Depois de fazer push, você terá:

1. Repositório público em GitHub para documentação
2. Histórico completo de commits
3. Backup seguro do código

Use uma das 3 opções acima e o código estará no GitHub!
