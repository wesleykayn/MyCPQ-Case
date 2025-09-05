## 1. Deploy the Changes

## From your project root (where sfdx-project.json is), <br>
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
________________________________________________________________________________________________________________

## 2. Verify Org Connection in CLI

Open your VS Code terminal and run:

```cmd
sf org list
```

or (legacy):
```cmd
sfdx force:org:list
```
<ul>
<li> If your sandbox alias (CPQ_SBX) appears in the list with a ✅, then VS Code (via Salesforce CLI) is connected to your sandbox.</li>
<li> You’ll see details like alias, username, org ID, instance URL, and expiration.</li>
</ul>

<details>
  <summary>📌</summary>
  <img width="1398" height="317" alt="image" src="https://github.com/user-attachments/assets/2b387d99-0019-4169-bb9d-27feb6fb8570" />
 
</details>



## Show Org Details

Run:
```cmd
sf org display --target-org CPQ_SBX
```

or:
```cmd
sfdx force:org:display -u CPQ_SBX

```

This will print sandbox details (username, instance URL, connected status).
If it errors, then the connection isn’t set up correctly.
