const main = async()=>{
    const[owner,randomAddress] = await hre.ethers.getSigners();
    const domainContractFactory = await hre.ethers.getContractFactory('EDomains');
    const domainContract = await domainContractFactory.deploy("rad")
    await domainContract.deployed()
    console.log("contract deployed to:",domainContract.address)
    console.log("Domain Owner address is: ",owner.address);

    let txn = await domainContract.register("heroine",  {value: hre.ethers.utils.parseEther('1')});
    await txn.wait();

    const domainOwner = await domainContract.getAddress("heroine");
    console.log("Owner of domain is:",domainOwner);

    let balance = await hre.ethers.provider.getBalance(domainContract.address);
    console.log("contract balance:",hre.ethers.utils.formatEther(balance));


}

const runMain= async()=>{
    try{
        await main();
        process.exit(0)
    } catch(err){
        console.log("Theres an error",err)
        process.exit(1)
    }

}
runMain();