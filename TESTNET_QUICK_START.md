# 🚀 Delta Neutral Vault - Testnet Quick Start

## ✅ Status (Nov 15, 2025)

**All setup completed on Arbitrum Sepolia:**

### Smart Contracts Deployed
- **Vault:** `0x844bc19AEB38436131c2b4893f5E0772162F67d6`
- **USDC:** `0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d` (testnet token)
- **WBTC Mock:** `0xEf39185d82F3Dd98046107D6Ca9bA2AF77a2B5dF` (deployed & minted)
- **USDC/WBTC Pool:** `0xB5AD58CBcc1a9DB06A9852b20aEc95FF3ba56F3a` (0.3% fee)

### Vault Configuration
✅ **Pool Configured** in vault: `0xB5AD58CBcc1a9DB06A9852b20aEc95FF3ba56F3a`
✅ **Range Set:** ticks [-530700, -528300] (multiples of tickSpacing 60)
✅ **Ready for Testing**

---

## 📋 What's Pre-Configured

The UI (`index.html`) already has:

1. **Pool Address:** Pre-filled with `0xB5AD58CBcc1a9DB06A9852b20aEc95FF3ba56F3a`
2. **Default Ticks:** Pre-filled with `-530700` and `-528300` (safe for current pool tick -529525)
3. **All Functions:** Connect, Deposit, Set Range, Position Info, Withdraw
4. **Network:** Already configured for Arbitrum Sepolia (chain ID 421614)

---

## 🎯 How to Test on UI

### Step 1: Open the UI
```bash
# Open index.html in your browser
# OR host it locally:
# npx http-server
```

### Step 2: Connect MetaMask
1. Click **"🔗 Connect MetaMask"** button
2. Select **Arbitrum Sepolia** network
3. Approve connection
4. Your wallet address should appear in the "Wallet Info" section

### Step 3: Deposit USDC
1. You need USDC on Arbitrum Sepolia
   - **Option A:** Use bridge from Ethereum Sepolia (if you have USDC there)
   - **Option B:** Ask for a faucet link
   - **Option C:** Check Arbitrum testnet faucets
   
2. Once you have USDC:
   - Enter amount in **"Deposit USDC"** section (e.g., 5 USDC)
   - Click **"Deposit"** button
   - Approve in MetaMask
   - Wait for tx confirmation

### Step 4: Verify Configuration
1. Go to **"⚙️ Configure Uniswap Pool"** section
2. Pool address should already be: `0xB5AD58CBcc1a9DB06A9852b20aEc95FF3ba56F3a`
3. Click **"Configure Pool"** button (even if already configured, it confirms)
4. Approve in MetaMask

### Step 5: Set Range
1. Go to **"📈 Set Range"** section
2. **Default ticks are already filled:** `-530700` and `-528300`
3. Click **"Set Range"** button
4. Approve in MetaMask
5. Wait for confirmation

### Step 6: Check Position
1. Go to **"🎯 Position Info"** section
2. Click **"Refresh Position"** button
3. You should see:
   - Token ID (your LP NFT ID)
   - Liquidity amount
   - Token amounts

### Step 7: Test Withdraw
1. Go to **"🔄 Withdraw"** section
2. Leave blank or enter shares amount
3. Click **"Withdraw"** button
4. Approve in MetaMask

---

## 🔗 Useful Links

### View on Arbitrum Sepolia Explorer
- **Vault:** https://sepolia.arbiscan.io/address/0x844bc19AEB38436131c2b4893f5E0772162F67d6
- **Pool:** https://sepolia.arbiscan.io/address/0xB5AD58CBcc1a9DB06A9852b20aEc95FF3ba56F3a
- **USDC:** https://sepolia.arbiscan.io/address/0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d
- **WBTC Mock:** https://sepolia.arbiscan.io/address/0xEf39185d82F3Dd98046107D6Ca9bA2AF77a2B5dF

### RPC & Network
- **RPC URL:** https://sepolia-rollup.arbitrum.io/rpc
- **Chain ID:** 421614
- **Currency:** ETH (Sepolia ETH for gas)

---

## 📊 Test Data

The deployer account has:
- **10 WBTC Mock** (8 decimals)
- **8 USDC** used for initial testing
- Can request more from faucets

---

## 🛠️ Troubleshooting

### "Pool not configured" error
- Go to Configure Pool section
- Verify address: `0xB5AD58CBcc1a9DB06A9852b20aEc95FF3ba56F3a`
- Click Configure Pool button again

### "Invalid ticks" error
- Ensure ticks are multiples of 60 (pool's tickSpacing)
- Use default: -530700 / -528300

### "Insufficient balance" error
- You need USDC on Arbitrum Sepolia
- Check balanceOf on Arbiscan
- Bridge or request from faucet

### Metamask connection issues
- Switch network to Arbitrum Sepolia manually
- Clear MetaMask cache if needed
- Reload page and reconnect

---

## ✨ Scripts Available

If you prefer Foundry/CLI testing:

```bash
# Check vault state
forge script script/CheckVaultState.s.sol --rpc-url https://sepolia-rollup.arbitrum.io/rpc

# Deposit USDC
forge script script/Deposit.s.sol --broadcast --rpc-url https://sepolia-rollup.arbitrum.io/rpc

# Check vault configuration
cast call 0x844bc19AEB38436131c2b4893f5E0772162F67d6 "uniswapPool()(address)" --rpc-url https://sepolia-rollup.arbitrum.io/rpc
```

---

## 📝 Next Steps for Production

1. Fully test deposit/withdraw flows on testnet
2. Monitor LP position changes
3. Test rebalancing logic
4. Audit before mainnet deployment
5. Deploy on mainnet with real assets

---

**Created:** Nov 15, 2025
**Network:** Arbitrum Sepolia (testnet)
**Status:** ✅ Ready for UI Testing
