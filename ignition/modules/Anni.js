const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
 

module.exports = buildModule("AnniModule", (m) => {
   

  const anni = m.contract("AnniToken");

  return { anni };
});
