// server_launch.js
// This is the master configuration file for the Swarm Network.
// It is automatically fetched by the desktop app and the miner worker.

window.HIRAYA_CONFIG = {
    server_ip: "16.176.49.158", // Automatically routes all apps to this backend IP
    miner_enabled: true,        // Set to false to remotely disable all mining nodes
    reward_rate: 50             // Approximate coins per hour per node
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
