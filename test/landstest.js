var land = artifacts.require("./lands.sol");
var Web3 = require('web3');
web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

contract('land test',async accounts =>{
  it("should register lands",async ()=>{
    let instance = await land.deployed();
    let landnumb = web3.fromAscii("er007fr");
    let loc = web3.fromAscii("kericho");
    let size =web3.fromAscii("24 acres");
    await instance.registerLand(landnumb,loc,size,24,-31,"27/02/1996","dskgdkgfk",{from: accounts[0]});
    
    let details = await instance.titleDetails(0);
    let lan = web3.toAscii(details.location)
    let re = await instance.registeredLands()
    //assert.strictEqual(lan,'kericho',"should have placed array of land details");
    let detail = await instance.landDetails(landnumb);
    assert.strictEqual(detail.registered,true);
    assert.strictEqual(detail.alloted, false);
    assert.strictEqual(detail.issueDate, "27/02/1996" )
    const num = re[0].length
    const lna = 0
    const sza = 1
    const loa = 2
    let struct =[]
    for (let i = 0; i < num; i++) {
      const p = {
        ln : re[lna][i],
        sz : re[sza][i],
        lo :re[loa][i]
      }
      struct.push(p)
    }
    console.log(struct[0])
    // assert.strictEqual(re[1], 1)
  }
  );
  it('allots land', async ()=>{
    let instance = await land.deployed()
    let landnumb = web3.fromAscii('er007fr')
    await instance.allotLand(accounts[2], landnumb)
    let detail = await instance.landDetails(landnumb)
    assert.strictEqual(detail.owner, accounts[2], 'accounts[0] is the deployer')
  });
  it('should allow intiate of land sell', async () => {
    let instance = await land.deployed()

  })
});
