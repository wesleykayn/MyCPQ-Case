# From your project root (where sfdx-project.json is), <br>
``` cmd
sf project deploy start --source-dir force-app --target-org CPQ_SBX --wait 10 
```
<ul>
<li><code>--source-dir force-app</code> → deploys everything in that folder (all your edits).</li>
<li><code>--target-org CPQ_SBX</code> → the alias you created earlier.</li>
<li><code>--wait 10</code> → wait up to 10 minutes for deployment to complete.</li>
</ul>


## Or deploy just the file(s) you changed:<br>
``` cmd
sf project deploy start --source-dir force-app/main/unpackaged/anon-apex/activateContracts.apex --target-org CPQ_SBX --wait 10  <br>
``` 

## Verify Deployment<br>
``` 
sf project deploy report --use-most-recent<br>
``` 
## Test Changes<br>
``` cmd
sfdx force:apex:execute -f force-app/main/unpackaged/anon-apex/activateContracts.apex -u CPQ_SBX<br>
``` 
