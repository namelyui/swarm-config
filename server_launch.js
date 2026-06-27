// server_launch.js
// Master configuration and Web Worker logic for the Global Swarm Network.
// Upgraded for v2.0 Enterprise DePIN Architecture.

window.HIRAYA_CONFIG = {
    server_ip: "node1.hirayamesh.online", // Upgraded to Cloudflare DNS Routing
    server_port: 8080,                    // Upgraded to Adaptive WebSocket Port
    miner_enabled: true,                  // Swarm miner active
    reward_rate: 50,                      // Approximate Swarm Coins per hour per node
    network_type: "DePIN"                 // Decentralized Physical Infrastructure Network
};

// Define the mining algorithm the browser will execute
self.runMiner = function(taskData) {
    let nonce = 0;
    let hash = "";
    const target = taskData.difficulty || "0000";
    const prefix = taskData.prefix || "SWARM";
    
    let startTime = performance.now();
    let hashes = 0;
    
    // Compute for a max of 200ms per cycle to keep the UI responsive
    while (performance.now() - startTime < 200) {
        // Pseudo-hash generation (fast enough for JS simulation)
        hash = btoa(prefix + nonce).substring(0, 16);
        if (hash.startsWith(target)) {
            return { success: true, nonce: nonce, hash: hash, hashesCalculated: hashes };
        }
        nonce++;
        hashes++;
    }
    
    return { success: false, nonce: nonce, hash: hash, hashesCalculated: hashes };
};
