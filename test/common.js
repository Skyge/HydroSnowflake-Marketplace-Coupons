const IdentityRegistry = artifacts.require('./_testing/IdentityRegistry.sol')
const HydroToken = artifacts.require('./_testing/HydroToken.sol')
const Snowflake = artifacts.require('./Snowflake.sol')
const ClientRaindrop = artifacts.require('./resolvers/ClientRaindrop/ClientRaindrop.sol')
const OldClientRaindrop = artifacts.require('./_testing/OldClientRaindrop.sol')

const CouponMarketplace = artifacts.require('./resolvers/CouponMarketplace.sol')

async function initialize (owner, users) {
  const instances = {}

  instances.HydroToken = await HydroToken.new({ from: owner })
  for (let i = 0; i < users.length; i++) {
    await instances.HydroToken.transfer(
      users[i].address,
      web3.utils.toBN(1000).mul(web3.utils.toBN(1e18)),
      { from: owner }
    )
  }

  instances.IdentityRegistry = await IdentityRegistry.new({ from: owner })

  instances.Snowflake = await Snowflake.new(
    instances.IdentityRegistry.address, instances.HydroToken.address, { from: owner }
  )

  instances.OldClientRaindrop = await OldClientRaindrop.new({ from: owner })

  instances.ClientRaindrop = await ClientRaindrop.new(
    instances.Snowflake.address, instances.OldClientRaindrop.address, 0, 0, { from: owner }
  )
  await instances.Snowflake.setClientRaindropAddress(instances.ClientRaindrop.address, { from: owner })


  /*instances.CouponMarketplace = await CouponMarketplace.new(1, "Test_Name", "Test_Desc", instances.Snowflake.address, false, false, {from: owner })*/

  return instances
}


async function deployCouponMarketplace (owner, snowflakeAddress, ein = 1, snowflakeName = "Test_Name", snowflakeDescription = "Test_Desc", callOnAddition = false, callOnRemoval = false) {

  const instances = {}
  instances.CouponMarketplace = await CouponMarketplace.new(ein, snowflakeName, snowflakeDescription, snowflakeAddress, callOnAddition, callOnRemoval, {from: owner })
  return instances;

}


module.exports = {
  initialize: initialize,
  deploy: {
    couponMarketplace: deployCouponMarketplace
  }
}
