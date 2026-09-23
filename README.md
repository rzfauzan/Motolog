# MotoLog

**MotoLog** is a decentralized application (DApp) that keeps a permanent, tamper-proof service history for vehicles on BOT Chain. Every maintenance record — service type, mileage, technician, and owner at the time of service — is written on-chain, so the history can never be lost, backdated, or falsified. Anyone, including a prospective buyer of a used vehicle, can verify a vehicle's full service record without needing a wallet or any special access.

## Problem it solves

Paper service records get lost, and handwritten mileage or dates can be altered. Buyers of used motorcycles have no reliable way to confirm a vehicle's real maintenance history. MotoLog moves that record on-chain: once a service is logged, it cannot be edited or deleted by anyone — not even the workshop that created it.

## How it works

1. **Register a vehicle** — the owner connects their wallet and registers the vehicle by name. The smart contract generates and assigns a unique verification ID automatically; no chassis number, engine number, or other sensitive identifier is ever published on-chain.
2. **Log a service record** — a workshop or technician submits a service entry (service type, mileage, technician name, owner name, optional notes) against the vehicle's ID. Each entry is permanently appended to that vehicle's on-chain history.
3. **Verify service history** — anyone can look up a vehicle by its ID and see its complete, chronological service record. No wallet connection is required for this step.

## Tech stack

- **Smart contract:** Solidity `^0.8.20`, deployed on BOT Chain (EVM-compatible)
- **Frontend:** Single static HTML file, vanilla JavaScript, [ethers.js](https://docs.ethers.org/v5/) for contract interaction, MetaMask for wallet connection
- **Hosting:** GitHub Pages

## Project structure

```
├── MyCertificate.sol     # Smart contract (source of truth for on-chain logic)
├── index.html            # Frontend — register vehicles, log services, verify history
└── README.md
```

## Smart contract overview

| Function | Description |
|---|---|
| `registerItem(itemId, itemName)` | Registers a new vehicle under a unique ID. Reverts if the ID is already taken or empty. |
| `addServiceRecord(itemId, serviceType, technician, ownerName, notes, mileage)` | Appends a new service record to an existing vehicle's history. |
| `getServiceHistory(itemId)` | Returns the full list of service records for a vehicle. |
| `getItem(itemId)` | Returns a vehicle's stored name and registration status. |

**Vehicle IDs** are randomly generated on the frontend (4–8 alphanumeric characters, excluding ambiguous characters like `0/O/1/I`) rather than assigned sequentially or derived from a real-world identifier such as a chassis or engine number. This keeps IDs unpredictable, collision-resistant, and free of any sensitive vehicle data — the contract itself rejects any ID that has already been registered.

## Running locally / deploying

### 1. Deploy the contract

1. Open [Remix IDE](https://remix.ethereum.org) and create `Motolog.sol` using the source in this repo.
2. Compile with Solidity `0.8.20`.
3. In **Deploy & Run**, set the environment to **Injected Provider – MetaMask**, connect to BOT Chain, and deploy.
4. Copy the deployed contract address.

### 2. Configure the frontend

Open `index.html` and set the following near the top of the `<script>` section:

```js
const CONTRACT_ADDRESS = "0xYourDeployedContractAddress";
const EXPLORER_BASE_URL = "https://scan.bohr.life/address";
```

### 3. Host it

Push `index.html` to a GitHub repository and enable **GitHub Pages** (Settings → Pages → deploy from branch). Point your domain to the generated GitHub Pages URL.

## Deployment

| Network | Contract Address |
|---|---|
| BOT Chain Testnet | `0x3929052C57270E2EbB855172033d4C092AF6887B` |
| BOT Chain Mainnet | `0x...` |

## Network details (BOT Chain Testnet)

| Field | Value |
|---|---|
| Network Name | BOT Chain Testnet |
| RPC URL | https://rpc.bohr.life |
| Chain ID | 968 |
| Currency Symbol | BOT |
| Block Explorer | https://scan.bohr.life/ |

| Field | Value |
|---|---|
| Network Name | BOT Chain Mainnet |
| RPC URL | https://rpc.botchain.ai |
| Chain ID | 677 |
| Currency Symbol | BOT |
| Block Explorer | 	https://scan.botchain.ai |

## License

MIT
