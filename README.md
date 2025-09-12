

## 1. Deploy the Changes

### From your project root (where sfdx-project.json is), <br>
``` cmd
sf project deploy start --source-dir force-app --target-org CPQ_SBX --wait 10
```
<ul>
<li><code>--source-dir force-app</code> → deploys everything in that folder (all your edits).</li>
<li><code>--target-org CPQ_SBX</code> → the alias you created earlier.</li>
<li><code>--wait 10</code> → wait up to 10 minutes for deployment to complete.</li>
</ul>
<details>
  <summary>📌</summary>
<img width="1442" height="641" alt="image" src="https://github.com/user-attachments/assets/92742c0c-28b2-429f-b861-638cb81414eb" />
<tt>The following table reflects the changes.</tt>
</details>

### Or deploy just the file(s) you changed:<br>
``` cmd
sf project deploy start --source-dir force-app/main/unpackaged/anon-apex/activateContracts.apex --target-org CPQ_SBX --wait 10  
``` 

## Verify Deployment<br>
``` cmd
sf project deploy report --use-most-recent
``` 
## Test Changes<br>
``` cmd
sfdx force:apex:execute -f force-app/main/unpackaged/anon-apex/activateContracts.apex -u CPQ_SBX
``` 
<tt>Note change the class/component name: ` activateContracts.apex` </tt>
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



### Show Org Details

Run:
```cmd
sf org display --target-org CPQ_SBX
```

or:
```cmd
sfdx force:org:display -u CPQ_SBX

```
<details>
  <summary>📌</summary>
⚠️ Warning: This command will expose sensitive information that allows for subsequent activity using your current authenticated session.
Sharing this information is equivalent to logging someone in under the current credential, resulting in unintended access and escalation of privilege.
</details>

This will print sandbox details (username, instance URL, connected status). <br>
If it errors, then the connection isn’t set up correctly.


___________________________________________________________________________________________________________

GitHub: https://github.com/rjhalvorson/cancelAndReplace/blob/master/force-app/main/unpackaged/anon-apex/activateContracts.apex <br>
Steps: [CancelAndReplaceSteps.pdf](https://github.com/user-attachments/files/22176462/CancelAndReplaceSteps.pdf)
<br>
changes: D:\cancelAndReplace\cancelAndReplace\force-app\main\default\lwc\activeContracts <br>



___________________________________________________________________________________________________________

## 3. Deploy in the Root Repo

## A) cd into the real project root, then deploy
#### 1) Go to the folder that has sfdx-project.json
```cmd
cd /d/cancelAndReplace/cancelAndReplace 
```

#### 2) (optional) set default target org
``` cmd
sf config set target-org=CPQ_SBX
```
#### 3) Deploy just the LWC bundle (folder, not a single .js file)
``` cmd
sf project deploy start \
  --source-dir force-app/main/default/lwc/activeContracts \
  --target-org CPQ_SBX \
  --ignore-conflicts \
  --wait 10
```
 Tip: You can also deploy by metadata name:
``` cmd
sf project deploy start --metadata "LightningComponentBundle:activeContracts" --target-org CPQ_SBX --wait 10
```
## B) Stay in your current folder but point --project-dir to the root

#### From: /d/cancelAndReplace
``` cmd
sf project deploy start \
  --project-dir D:/cancelAndReplace/cancelAndReplace \
  --source-dir force-app/main/default/lwc/activeContracts \
  --target-org CPQ_SBX \
  --ignore-conflicts \
  --wait 10
```

