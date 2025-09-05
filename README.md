#From your project root (where sfdx-project.json is):
sf project deploy start --source-dir force-app --target-org CPQ_SBX --wait 10
<ul>
--source-dir force-app → deploys everything in that folder (all your edits).
--target-org CPQ_SBX → the alias you created earlier.
--wait 10 → wait up to 10 minutes for deployment to complete.
</ul>

##Or deploy just the file(s) you changed:
sf project deploy start --source-dir force-app/main/unpackaged/anon-apex/activateContracts.apex --target-org CPQ_SBX --wait 10


##Verify Deployment

sf project deploy report --use-most-recent

##Test Changes

sfdx force:apex:execute -f force-app/main/unpackaged/anon-apex/activateContracts.apex -u CPQ_SBX
