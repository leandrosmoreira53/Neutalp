#!/bin/bash

# Simple check without forge - just view the vault on Etherscan
echo "=== VAULT STATUS ==="
echo "Vault Address: 0x6cf5791356EEf878536Ee006f18410861D93198D"
echo "Network: Arbitrum Sepolia"
echo "Explorer: https://sepolia.arbiscan.io/address/0x6cf5791356EEf878536Ee006f18410861D93198D"
echo ""
echo "Check status on Etherscan:"
echo "1. Read Contract tab to see balances and positions"
echo "2. Write Contract to execute deposit/withdraw"
echo ""
echo "Or use Cast CLI:"
echo "cast call 0x6cf5791356EEf878536Ee006f18410861D93198D \"name()\" --rpc-url https://sepolia-rollup.arbitrum.io/rpc"
